import 'package:source_span/source_span.dart';
import 'package:tuple/tuple.dart';

void main() {
  final source = '1 + 2 * 3 * (1 + 2)';
  final result = parse(source);
  print(result);
}

num _calculate(num left, String operator, num right) {
  switch (operator) {
    case '+':
      return left + right;
    case '-':
      return left - right;
    case '*':
      return left * right;
    case '/':
      return left / right;
    case '~/':
      return left ~/ right;
    default:
      throw StateError('Unknown operator: $operator');
  }
}

num parse(String source) {
  final state = State(source);
  final result = _parse(state);
  if (!state.ok) {
    final errors = Err.errorReport(state.error);
    final message = _errorMessage(source, errors);
    throw FormatException('\n$message');
  }

  return result!;
}

num? _parse(State<String> state) {
  num? $0;
  final source = state.source;
  final $pos = state.pos;
  $0 = _expression(state);
  if (state.ok) {
    state.ok = state.pos >= source.length;
    if (!state.ok && state.log) {
      state.error = ErrExpected.eof(state.pos);
    }
  }
  if (!state.ok) {
    $0 = null;
    state.pos = $pos;
  }
  return $0;
}

void _ws(State<String> state) {
  final source = state.source;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 32 && (c >= 9 && c <= 10 || c == 13 || c == 32);
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = true;
}

num? _integer(State<String> state) {
  num? $0;
  final source = state.source;
  final $pos = state.pos;
  String? $1;
  final $pos1 = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c >= 48 && c <= 57;
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = state.pos != $pos1;
  if (state.ok) {
    $1 = source.substring($pos1, state.pos);
  } else if (state.log) {
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  if (state.ok) {
    final v = $1!;
    $0 = int.parse(v);
  }
  if (state.ok) {
    _ws(state);
  }
  if (!state.ok) {
    $0 = null;
    state.pos = $pos;
  }
  return $0;
}

String? _openParen(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 40;
  if (state.ok) {
    state.pos += 1;
    $0 = '(';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('('));
  }
  if (state.ok) {
    _ws(state);
  }
  if (!state.ok) {
    $0 = null;
    state.pos = $pos;
  }
  return $0;
}

String? _closeParen(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 41;
  if (state.ok) {
    state.pos += 1;
    $0 = ')';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag(')'));
  }
  if (state.ok) {
    _ws(state);
  }
  if (!state.ok) {
    $0 = null;
    state.pos = $pos;
  }
  return $0;
}

num? _primary(State<String> state) {
  num? $0;
  $0 = _integer(state);
  if (!state.ok) {
    final $1 = state.error;
    final $pos = state.pos;
    _openParen(state);
    if (state.ok) {
      $0 = _expression(state);
      if (state.ok) {
        _closeParen(state);
      }
    }
    if (!state.ok) {
      $0 = null;
      state.pos = $pos;
    }
    if (!state.ok) {
      final $2 = state.error;
      if (state.log) {
        state.error = ErrCombined(state.pos, [$1, $2]);
      }
    }
  }
  return $0;
}

String? _multiplicativeOperator(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final pos = state.pos;
    final c = source.codeUnitAt(pos);
    String? v;
    switch (c) {
      case 42:
        state.pos++;
        v = '*';
        break;
      case 47:
        state.pos++;
        v = '/';
        break;
      case 126:
        if (source.startsWith('~/', pos)) {
          state.pos += 2;
          v = '~/';
          break;
        }
        break;
    }
    state.ok = v != null;
    if (state.ok) {
      $0 = v;
    }
  }
  if (!state.ok && state.log) {
    state.error = ErrCombined(state.pos, [
      ErrExpected.tag(state.pos, const Tag('*')),
      ErrExpected.tag(state.pos, const Tag('/')),
      ErrExpected.tag(state.pos, const Tag('~/'))
    ]);
  }
  if (state.ok) {
    _ws(state);
  }
  if (!state.ok) {
    $0 = null;
    state.pos = $pos;
  }
  return $0;
}

num? _multiplicative(State<String> state) {
  num? $0;
  final $list = <Tuple2<String, num>>[];
  var $ok = false;
  num? $1;
  $1 = _primary(state);
  if (state.ok) {
    $ok = true;
    while (true) {
      final $pos = state.pos;
      String? $2;
      $2 = _multiplicativeOperator(state);
      if (!state.ok) {
        break;
      }
      num? $3;
      $3 = _primary(state);
      if (!state.ok) {
        state.pos = $pos;
        break;
      }
      $list.add(Tuple2($2!, $3!));
    }
  }
  state.ok = $ok;
  if (state.ok) {
    var left = $1!;
    for (var i = 0; i < $list.length; i++) {
      final v = $list[i];
      left = _calculate(left, v.item1, v.item2);
    }
    $0 = left;
  }
  return $0;
}

String? _additiveOperator(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final pos = state.pos;
    final c = source.codeUnitAt(pos);
    String? v;
    switch (c) {
      case 43:
        state.pos++;
        v = '+';
        break;
      case 45:
        state.pos++;
        v = '-';
        break;
    }
    state.ok = v != null;
    if (state.ok) {
      $0 = v;
    }
  }
  if (!state.ok && state.log) {
    state.error = ErrCombined(state.pos, [
      ErrExpected.tag(state.pos, const Tag('+')),
      ErrExpected.tag(state.pos, const Tag('-'))
    ]);
  }
  if (state.ok) {
    _ws(state);
  }
  if (!state.ok) {
    $0 = null;
    state.pos = $pos;
  }
  return $0;
}

num? _additive(State<String> state) {
  num? $0;
  final $list = <Tuple2<String, num>>[];
  var $ok = false;
  num? $1;
  $1 = _multiplicative(state);
  if (state.ok) {
    $ok = true;
    while (true) {
      final $pos = state.pos;
      String? $2;
      $2 = _additiveOperator(state);
      if (!state.ok) {
        break;
      }
      num? $3;
      $3 = _multiplicative(state);
      if (!state.ok) {
        state.pos = $pos;
        break;
      }
      $list.add(Tuple2($2!, $3!));
    }
  }
  state.ok = $ok;
  if (state.ok) {
    var left = $1!;
    for (var i = 0; i < $list.length; i++) {
      final v = $list[i];
      left = _calculate(left, v.item1, v.item2);
    }
    $0 = left;
  }
  return $0;
}

num? _expression(State<String> state) {
  num? $0;
  $0 = _additive(state);
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
  int failure = 0;

  @override
  int get hashCode => length.hashCode ^ offset.hashCode;

  int get length;

  int get offset;

  @override
  bool operator ==(other) {
    return other is Err && other.length == length && other.offset == offset;
  }

  int getFailurePosition() => _max(failure, offset);

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
      final errors = <Err>[];
      _flatten(error.error, errors);
      final furthest = errors.map((e) => e.getFailurePosition()).reduce(_max);
      errors.removeWhere((e) => e.getFailurePosition() < furthest);
      final maxEnd = errors.map((e) => e.offset + e.length).reduce(_max);
      final offset = error.offset;
      final expected = ErrExpected.tag(offset, error.tag);
      expected.failure = furthest;
      result.add(expected);
      if (furthest > offset) {
        final message = ErrMessage(offset, maxEnd - offset, error.message);
        message.failure = furthest;
        result.add(message);
        result.addAll(errors);
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
    final result = errors.toList();
    final furthest = result.isEmpty
        ? -1
        : result.map((e) => e.getFailurePosition()).reduce(_max);
    result.removeWhere((e) => e.getFailurePosition() < furthest);
    final map = <int, List<ErrExpected>>{};
    for (final error in result.whereType<ErrExpected>()) {
      final offset = error.offset;
      var list = map[offset];
      if (list == null) {
        list = [];
        map[offset] = list;
      }

      list.add(error);
    }

    result.removeWhere((e) => e is ErrExpected);
    for (var offset in map.keys) {
      final list = map[offset]!;
      final values = list.map((e) => e.value).join(', ');
      result.add(ErrMessage(offset, 0, 'Expected: $values'));
    }

    return result;
  }

  static List<Err> _preprocess(Err error) {
    final result = <Err>[];
    _flatten(error, result);
    return result.toSet().toList();
  }
}

class ErrCombined extends Err {
  final List<Err> errors;

  @override
  final int offset;

  ErrCombined(this.offset, this.errors);

  @override
  int get hashCode {
    var result = super.hashCode;
    for (final error in errors) {
      result ^= error.hashCode;
    }

    return result;
  }

  @override
  int get length => 1;

  @override
  bool operator ==(other) {
    if (super == other) {
      if (other is ErrCombined) {
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
  int get length => 0;

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

class ErrNested extends Err {
  final Err error;

  final String message;

  @override
  final int offset;

  final Tag tag;

  ErrNested(this.offset, this.message, this.tag, this.error);

  @override
  int get hashCode =>
      super.hashCode ^ error.hashCode ^ message.hashCode ^ tag.hashCode;

  @override
  int get length => 0;

  @override
  bool operator ==(other) {
    return super == other &&
        other is ErrNested &&
        other.error == error &&
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
      : length = offset < source.length ? 1 : 0,
        value = offset < source.length
            ? Char(c ?? source.runeAt(offset))
            : const Tag('EOF');

  ErrUnexpected.eof(this.offset)
      : length = 0,
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
  int get length => 0;

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
