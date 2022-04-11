// ignore_for_file: unnecessary_cast

import 'package:source_span/source_span.dart';
import 'package:tuple/tuple.dart';

List<Tuple2<int, int>> parseString(String source) {
  final state = State(source);
  final result = parse(state);
  if (!state.ok) {
    final errors = Err.errorReport(state.error);
    final message = _errorMessage(source, errors);
    throw FormatException('\n$message');
  }

  return result!;
}

void _ws(State<String> state) {
  final source = state.source;
  while (true) {
    final $pos = state.pos;
    int? $c;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $c = source.readRune(state);
      state.ok = $c == 0x09 || $c == 0xA || $c == 0xD || $c == 0x20;
    }
    if (!state.ok) {
      state.pos = $pos;
      break;
    }
  }
  state.ok = true;
}

int? _hexVal(State<String> state) {
  final source = state.source;
  int? $0;
  String? $1;
  final $pos = state.pos;
  var $ok = false;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $c = source.readRune(state);
      state.ok = $c >= 0x30 && $c <= 0x39 ||
          $c >= 0x41 && $c <= 0x46 ||
          $c >= 0x61 && $c <= 0x66;
    }
    if (state.ok) {
      $ok = true;
    } else {
      state.pos = $pos1;
      state.error = $c == null
          ? ErrUnexpected.eof(state.pos)
          : ErrUnexpected.char(state.pos, Char($c));
      break;
    }
  }
  state.ok = $ok;
  if (state.ok) {
    $1 = state.source.slice($pos, state.pos) as String?;
    final v = $1!;
    $0 = _toHexValue(v) as int?;
  }
  return $0;
}

int? _hex(State<String> state) {
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  state.ok = state.pos + 1 < source.length &&
      source.codeUnitAt(state.pos) == 35 &&
      source.codeUnitAt(state.pos + 1) == 120;
  if (state.ok) {
    state.pos += 2;
    int? $2;
    $2 = _hexVal(state);
    if (state.ok) {
      $0 = $2;
    } else {
      state.pos = $pos;
    }
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('#x'));
  }
  return $0;
}

int? _rangeChar(State<String> state) {
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  final $pos1 = state.pos;
  state.ok = false;
  final $pos2 = state.pos;
  if (state.pos < source.length) {
    final c = source.codeUnitAt($pos2);
    switch (c) {
      case 91:
        state.pos++;
        state.ok = true;
        break;
      case 93:
        state.pos++;
        state.ok = true;
        break;
    }
  }
  state.ok = !state.ok;
  if (!state.ok) {
    state.pos = $pos1;
    state.error = ErrUnknown(state.pos);
  } else {
    int? $3;
    final $pos3 = state.pos;
    int? $c;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $c = source.readRune(state);
      state.ok = $c >= 0x20 && $c < 0x7f;
    }
    if (state.ok) {
      $3 = $c as int?;
      $0 = $3;
    } else {
      state.pos = $pos3;
      state.error = $c == null
          ? ErrUnexpected.eof(state.pos)
          : ErrUnexpected.char(state.pos, Char($c));
      state.pos = $pos;
    }
  }
  return $0;
}

int? _hexOrRangeChar(State<String> state) {
  int? $0;
  int? $1;
  $1 = _hex(state);
  if (state.ok) {
    $0 = $1;
  } else {
    final $error = state.error;
    int? $2;
    $2 = _rangeChar(state);
    if (state.ok) {
      $0 = $2;
    } else {
      state.error = ErrCombined(state.pos, [$error, state.error]);
    }
  }
  return $0;
}

Tuple2<int, int>? _rangeBody(State<String> state) {
  final source = state.source;
  Tuple2<int, int>? $0;
  Tuple2<int, int>? $1;
  final $pos = state.pos;
  int? $2;
  $2 = _hexOrRangeChar(state);
  if (state.ok) {
    state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 45;
    if (state.ok) {
      state.pos += 1;
      int? $4;
      $4 = _hexOrRangeChar(state);
      if (state.ok) {
        $1 = Tuple2($2!, $4!) as Tuple2<int, int>?;
        $0 = $1;
      }
    } else {
      state.error = ErrExpected.tag(state.pos, const Tag('-'));
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    final $error = state.error;
    Tuple2<int, int>? $5;
    int? $6;
    $6 = _hex(state);
    if (state.ok) {
      final v = $6!;
      $5 = Tuple2(v, v) as Tuple2<int, int>?;
      $0 = $5;
    } else {
      final $error1 = state.error;
      Tuple2<int, int>? $7;
      int? $8;
      $8 = _rangeChar(state);
      if (state.ok) {
        final v = $8!;
        $7 = Tuple2(v, v) as Tuple2<int, int>?;
        $0 = $7;
      } else {
        state.error = ErrCombined(state.pos, [$error, $error1, state.error]);
      }
    }
  }
  return $0;
}

int? _charCode(State<String> state) {
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  int? $c;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $c = source.readRune(state);
    state.ok = $c >= 0x20 && $c < 0x7f;
  }
  if (state.ok) {
    $0 = $c as int?;
  } else {
    state.pos = $pos;
    state.error = $c == null
        ? ErrUnexpected.eof(state.pos)
        : ErrUnexpected.char(state.pos, Char($c));
  }
  return $0;
}

int? _char(State<String> state) {
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 34;
  if (state.ok) {
    state.pos += 1;
    int? $2;
    $2 = _charCode(state);
    if (state.ok) {
      state.ok =
          state.pos < source.length && source.codeUnitAt(state.pos) == 34;
      if (state.ok) {
        state.pos += 1;
        $0 = $2;
      } else {
        state.error = ErrExpected.tag(state.pos, const Tag('"'));
      }
    }
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('"'));
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

List<Tuple2<int, int>>? _range(State<String> state) {
  final source = state.source;
  List<Tuple2<int, int>>? $0;
  List<Tuple2<int, int>>? $1;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 91;
  if (state.ok) {
    state.pos += 1;
    List<Tuple2<int, int>>? $3;
    final $list = <Tuple2<int, int>>[];
    while (true) {
      Tuple2<int, int>? $4;
      $4 = _rangeBody(state);
      if (!state.ok) {
        break;
      }
      $list.add($4!);
    }
    state.ok = $list.isNotEmpty;
    if (state.ok) {
      $3 = $list as List<Tuple2<int, int>>?;
      state.ok =
          state.pos < source.length && source.codeUnitAt(state.pos) == 93;
      if (state.ok) {
        state.pos += 1;
        $1 = $3;
        $0 = $1;
      } else {
        state.error = ErrExpected.tag(state.pos, const Tag(']'));
      }
    }
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('['));
  }
  if (!state.ok) {
    state.pos = $pos;
    final $error = state.error;
    List<Tuple2<int, int>>? $6;
    int? $7;
    int? $8;
    $8 = _char(state);
    if (state.ok) {
      $7 = $8;
    } else {
      final $error1 = state.error;
      int? $9;
      $9 = _hex(state);
      if (state.ok) {
        $7 = $9;
      } else {
        state.error = ErrCombined(state.pos, [$error1, state.error]);
        state.error = ErrCombined(state.pos, [$error, state.error]);
      }
    }
    if (state.ok) {
      final v = $7!;
      $6 = [Tuple2(v, v)] as List<Tuple2<int, int>>?;
      $0 = $6;
    }
  }
  return $0;
}

String? _verbar(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  String? $1;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 124;
  if (state.ok) {
    state.pos += 1;
    $1 = '|' as String?;
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = $pos;
    }
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('|'));
  }
  return $0;
}

List<Tuple2<int, int>>? _ranges(State<String> state) {
  List<Tuple2<int, int>>? $0;
  List<List<Tuple2<int, int>>>? $1;
  var $pos = state.pos;
  final $list = <List<Tuple2<int, int>>>[];
  for (;;) {
    List<Tuple2<int, int>>? $2;
    final $pos1 = state.pos;
    List<Tuple2<int, int>>? $3;
    $3 = _range(state);
    if (state.ok) {
      _ws(state);
      if (state.ok) {
        $2 = $3;
        $list.add($2!);
      } else {
        state.pos = $pos1;
      }
    }
    if (!state.ok) {
      state.pos = $pos;
      break;
    }
    $pos = state.pos;
    _verbar(state);
    if (!state.ok) {
      break;
    }
  }
  state.ok = $list.isNotEmpty;
  if (state.ok) {
    $1 = $list as List<List<Tuple2<int, int>>>?;
    final v = $1!;
    $0 = _flatten(v, <Tuple2<int, int>>[]) as List<Tuple2<int, int>>?;
  }
  return $0;
}

List<Tuple2<int, int>>? parse(State<String> state) {
  List<Tuple2<int, int>>? $0;
  final $pos = state.pos;
  _ws(state);
  if (state.ok) {
    List<Tuple2<int, int>>? $2;
    $2 = _ranges(state);
    if (state.ok) {
      state.ok = state.pos >= state.source.length;
      if (!state.ok) {
        state.error = ErrExpected.eof(state.pos);
      } else {
        $0 = $2;
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
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

List<T> _flatten<T>(List<List<T>> data, List<T> result) {
  for (final item1 in data) {
    for (final item2 in item1) {
      result.add(item2);
    }
  }

  return result;
}

int _toHexValue(String s) {
  final l = s.codeUnits;
  var r = 0;
  for (var i = l.length - 1, j = 0; i >= 0; i--, j += 4) {
    final c = l[i];
    var v = 0;
    if (c >= 0x30 && c <= 0x39) {
      v = c - 0x30;
    } else if (c >= 0x41 && c <= 0x46) {
      v = c - 0x41 + 10;
    } else if (c >= 0x61 && c <= 0x66) {
      v = c - 0x61 + 10;
    } else {
      throw StateError('Internal error');
    }

    r += v * (1 << j);
  }

  return r;
}
