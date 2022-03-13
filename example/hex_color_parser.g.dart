part of 'hex_color_parser.dart';

Color parseString(String source) {
  final state = State(source);
  final result = _parse(state);
  if (!state.ok) {
    final errors = Err.errorReport(state.error);
    final message = _errorMessage(source, errors);
    throw FormatException('\n$message');
  }

  return result!;
}

int? _hexPrimary(State<String> state) {
  final source = state.source;
  int? $0;
  String? $1;
  final $pos = state.pos;
  var $cnt = 0;
  while ($cnt < 2 && state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 102 &&
        (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102);
    if (ok) {
      state.pos++;
      $cnt++;
      continue;
    }
    break;
  }
  state.ok = $cnt >= 2;
  if (state.ok) {
    $1 = source.substring($pos, state.pos);
  } else {
    if (state.log) {
      state.error = ErrUnexpected.charOrEof(state.pos, source);
    }
    state.pos = $pos;
  }
  if (state.ok) {
    final v = $1!;
    $0 = int.parse(v, radix: 16);
  }
  return $0;
}

Color? _hexColor(State<String> state) {
  final source = state.source;
  Color? $0;
  final $pos = state.pos;
  String? $1;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 35;
  if (state.ok) {
    state.pos++;
    $1 = '#';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('#'));
  }
  if (state.ok) {
    Color? $2;
    final $pos1 = state.pos;
    int? $3;
    $3 = _hexPrimary(state);
    if (state.ok) {
      int? $4;
      $4 = _hexPrimary(state);
      if (state.ok) {
        int? $5;
        $5 = _hexPrimary(state);
        if (state.ok) {
          $2 = Color($3!, $4!, $5!);
        }
      }
    }
    if (!state.ok) {
      state.pos = $pos1;
    }
    if (state.ok) {
      $0 = $2!;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

Color? _parse(State<String> state) {
  Color? $0;
  $0 = _hexColor(state);
  return $0;
}

String _errorMessage(String source, List<Err> errors,
    [color, int maxCount = 10, String? url]) {
  final sb = StringBuffer();
  for (var i = 0; i < errors.length; i++) {
    if (i > maxCount) {
      break;
    }

    final error = errors[i];
    if (error.offset + error.length > source.length) {
      source += ' ' * (error.offset + error.length - source.length);
    }

    final file = SourceFile.fromString(source, url: url);
    final span = file.span(error.offset, error.offset + error.length);
    if (sb.isNotEmpty) {
      sb.writeln();
    }

    sb.write(span.message(error.toString(), color: color));
  }

  if (errors.length > maxCount) {
    sb.writeln();
    sb.write('(${errors.length - maxCount} more errors...)');
  }

  return sb.toString();
}

/// Represents the `char` used in parsing errors.
class Char {
  final int charCode;

  const Char(this.charCode);

  @override
  int get hashCode => charCode.hashCode;

  @override
  operator ==(other) {
    return other is Char && other.charCode == charCode;
  }

  @override
  String toString() {
    final s = String.fromCharCode(charCode)._escape();
    return '\'$s\'';
  }
}

abstract class Err {
  @override
  int get hashCode => length.hashCode ^ offset.hashCode;

  int get length;

  int get offset;

  @override
  bool operator ==(other) {
    return other is Err && other.length == length && other.offset == offset;
  }

  static List<Err> errorReport(Err error) {
    var result = _preprocess(error);
    result = _postprocess(result);
    return result;
  }

  static void _flatten(Err error, List<Err> result) {
    if (error is ErrCombined) {
      for (final error in error.errors) {
        _flatten(error, result);
      }
    } else if (error is ErrNested) {
      final inner = <Err>[];
      for (final nested in error.errors) {
        _flatten(nested, inner);
      }

      final farthest = inner.map((e) => e.offset).reduce(_max);
      inner.removeWhere((e) => e.offset < farthest);
      final offset = error.offset;
      final tag = error.tag;
      if (tag != null) {
        result.add(ErrExpected.tag(offset, tag));
      }

      if (farthest > offset) {
        result.add(_ErrInner(farthest, offset, error.message));
        result.addAll(inner);
      }
    } else {
      result.add(error);
    }
  }

  static int _max(int x, int y) {
    if (x > y) {
      return x;
    }
    return y > x ? y : x;
  }

  static List<Err> _postprocess(List<Err> errors) {
    var result = errors.toList();
    final farthest =
        result.isEmpty ? -1 : result.map((e) => e.offset).reduce(_max);
    result.removeWhere((e) => e.offset < farthest);
    final expected =
        result.whereType<ErrExpected>().map((e) => '${e.value}').toList();
    if (expected.isNotEmpty) {
      expected.sort();
      result.removeWhere((e) => e is ErrExpected);
      result.add(ErrMessage(farthest, 1, 'Expected: ${expected.join(', ')}'));
    }

    for (var i = 0; i < result.length; i++) {
      final error = result[i];
      if (error is _ErrInner) {
        final length = error.offset;
        error.offset = error.length;
        error.length = length;
      }
    }

    return result;
  }

  static List<Err> _preprocess(Err error) {
    final result = <Err>[];
    _flatten(error, result);
    return result.toSet().toList();
  }
}

class ErrCombined extends ErrWithErrors {
  @override
  final List<Err> errors;

  @override
  final int offset;

  ErrCombined(this.offset, this.errors);

  @override
  int get length => 1;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return super == other && other is ErrCombined;
  }
}

class ErrExpected extends Err {
  @override
  final int offset;

  final Object? value;

  ErrExpected(this.offset, this.value);

  ErrExpected.char(this.offset, Char value) : value = value;

  ErrExpected.eof(this.offset) : value = const Tag('EOF');

  ErrExpected.label(this.offset, String value) : value = value;

  ErrExpected.tag(this.offset, Tag value) : value = value;

  @override
  int get hashCode => super.hashCode ^ value.hashCode;

  @override
  int get length => 1;

  @override
  bool operator ==(other) {
    return super == other && other is ErrExpected && other.value == value;
  }

  @override
  String toString() {
    final result = 'Expected: $value';
    return result;
  }
}

class ErrMessage extends Err {
  @override
  final int length;

  final String message;

  @override
  final int offset;

  ErrMessage(this.offset, this.length, this.message);

  @override
  int get hashCode => super.hashCode ^ message.hashCode;

  @override
  bool operator ==(other) {
    return super == other && other is ErrMessage && other.message == message;
  }

  @override
  String toString() {
    return message;
  }
}

class ErrNested extends ErrWithErrors {
  @override
  final List<Err> errors;

  final String message;

  @override
  final int offset;

  final Tag? tag;

  ErrNested(this.offset, this.message, this.tag, this.errors);

  @override
  int get length => 1;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return super == other &&
        other is ErrNested &&
        other.message == message &&
        other.tag == tag;
  }

  @override
  String toString() {
    return message;
  }
}

class ErrUnexpected extends Err {
  @override
  final int length;

  @override
  final int offset;

  final Object? value;

  ErrUnexpected(this.offset, this.length, this.value);

  ErrUnexpected.char(this.offset, Char value)
      : length = 1,
        value = value;

  ErrUnexpected.charAt(this.offset, String source)
      : length = 1,
        value = Char(source.runeAt(offset));

  ErrUnexpected.charOrEof(this.offset, String source, [int? c])
      : length = 1,
        value = offset < source.length
            ? Char(c ?? source.runeAt(offset))
            : const Tag('EOF');

  ErrUnexpected.eof(this.offset)
      : length = 1,
        value = const Tag('EOF');

  ErrUnexpected.label(this.offset, String value)
      : length = value.length,
        value = value;

  ErrUnexpected.tag(this.offset, Tag value)
      : length = value.name.length,
        value = value;

  @override
  int get hashCode => super.hashCode ^ value.hashCode;

  @override
  bool operator ==(other) {
    return super == other && other is ErrUnexpected && other.value == value;
  }

  @override
  String toString() {
    final result = 'Unexpected: $value';
    return result;
  }
}

class ErrUnknown extends Err {
  @override
  final int offset;

  ErrUnknown(this.offset);

  @override
  int get length => 1;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return super == other && other is ErrUnknown;
  }

  @override
  String toString() {
    final result = 'Unknown error';
    return result;
  }
}

abstract class ErrWithErrors extends Err {
  List<Err> get errors;

  @override
  int get hashCode {
    var result = super.hashCode;
    for (final error in errors) {
      result ^= error.hashCode;
    }

    return result;
  }

  @override
  bool operator ==(other) {
    if (super == other) {
      if (other is ErrWithErrors) {
        final otherErrors = other.errors;
        if (otherErrors.length == errors.length) {
          for (var i = 0; i < errors.length; i++) {
            final error = errors[i];
            final otherError = otherErrors[i];
            if (otherError != error) {
              return false;
            }
          }

          return true;
        }
      }
    }

    return false;
  }

  @override
  String toString() {
    final list = errors.join(', ');
    final result = '[$list]';
    return result;
  }
}

abstract class ErrWithTagAndErrors extends ErrWithErrors {
  Tag get tag;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return super == other && other is ErrWithTagAndErrors && other.tag == tag;
  }
}

class State<T> {
  dynamic context;

  Err error = ErrUnknown(0);

  bool log = true;

  bool ok = false;

  int pos = 0;

  final T source;

  State(this.source);

  @override
  String toString() {
    if (source is String) {
      final s = source as String;
      if (pos >= s.length) {
        return '$pos:';
      }

      var length = s.length - pos;
      length = length > 40 ? 40 : length;
      final string = s.substring(pos, pos + length);
      return '$pos:$string';
    } else {
      return super.toString();
    }
  }
}

/// Represents the `tag` (symbol) used in parsing errors.
class Tag {
  final String name;

  const Tag(this.name);

  @override
  int get hashCode => name.hashCode;

  @override
  operator ==(other) {
    return other is Tag && other.name == name;
  }

  @override
  String toString() {
    final s = name._escape();
    return '\'$s\'';
  }
}

class _ErrInner extends Err {
  @override
  int length;

  String message;

  @override
  int offset;

  _ErrInner(this.offset, this.length, this.message);

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return super == other && other is _ErrInner && other.message == message;
  }

  @override
  String toString() {
    return message;
  }
}

extension on String {
  @pragma('vm:prefer-inline')
  // ignore: unused_element
  int readRune(State<String> state) {
    final w1 = codeUnitAt(state.pos++);
    if (w1 > 0xd7ff && w1 < 0xe000) {
      if (state.pos < length) {
        final w2 = codeUnitAt(state.pos++);
        if ((w2 & 0xfc00) == 0xdc00) {
          return 0x10000 + ((w1 & 0x3ff) << 10) + (w2 & 0x3ff);
        }

        state.pos--;
      }

      throw FormatException('Invalid UTF-16 character', this, state.pos - 1);
    }

    return w1;
  }

  @pragma('vm:prefer-inline')
  // ignore: unused_element
  int runeAt(int index) {
    final w1 = codeUnitAt(index++);
    if (w1 > 0xd7ff && w1 < 0xe000) {
      if (index < length) {
        final w2 = codeUnitAt(index);
        if ((w2 & 0xfc00) == 0xdc00) {
          return 0x10000 + ((w1 & 0x3ff) << 10) + (w2 & 0x3ff);
        }
      }

      throw FormatException('Invalid UTF-16 character', this, index - 1);
    }

    return w1;
  }

  /// Returns a slice (substring) of the string from [start] to [end].
  @pragma('vm:prefer-inline')
  // ignore: unused_element
  String slice(int start, int end) {
    return substring(start, end);
  }

  String _escape() {
    final map = {
      '\b': '\\b',
      '\f': '\\f',
      '\n': '\\n',
      '\r': '\\t',
      '\t': '\\t',
      '\v': '\\v',
    };

    var s = this;
    for (final key in map.keys) {
      s = s.replaceAll(key, map[key]!);
    }

    return s;
  }
}
