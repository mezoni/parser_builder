// ignore_for_file: unused_local_variable

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

bool? _ws(State<String> state) {
  final source = state.source;
  bool? $0;
  state.ok = true;
  while (state.pos < source.length) {
    final pos = state.pos;
    final c = source.readRune(state);
    final ok = c == 0x09 || c == 0xA || c == 0xD || c == 0x20;
    if (ok) {
      continue;
    }
    state.pos = pos;
    break;
  }
  if (state.ok) {
    $0 = true;
  }
  return $0;
}

int? _hexVal(State<String> state) {
  final source = state.source;
  int? $0;
  String? $1;
  state.ok = false;
  final $pos = state.pos;
  var $c = 0;
  while (state.pos < source.length) {
    final pos = state.pos;
    $c = source.readRune(state);
    final ok = $c >= 0x30 && $c <= 0x39 ||
        $c >= 0x41 && $c <= 0x46 ||
        $c >= 0x61 && $c <= 0x66;
    if (ok) {
      continue;
    }
    state.pos = pos;
    break;
  }
  state.ok = state.pos != $pos;
  if (state.ok) {
    $1 = source.substring($pos, state.pos);
  } else if (state.log) {
    state.error = ErrUnexpected.charOrEof(state.pos, source, $c);
  }
  if (state.ok) {
    final v = $1!;
    $0 = _toHexValue(v);
  }
  return $0;
}

int? _hex(State<String> state) {
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  String? $1;
  state.ok = state.pos + 1 < source.length &&
      source.codeUnitAt(state.pos) == 35 &&
      source.codeUnitAt(state.pos + 1) == 120;
  if (state.ok) {
    state.pos += 2;
    $1 = '#x';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('#x'));
  }
  if (state.ok) {
    int? $2;
    $2 = _hexVal(state);
    if (state.ok) {
      $0 = $2!;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

int? _rangeChar(State<String> state) {
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  bool? $1;
  final $log = state.log;
  state.log = false;
  final $pos1 = state.pos;
  String? $2;
  state.ok = false;
  final $pos2 = state.pos;
  if (state.pos < source.length) {
    final c = source.codeUnitAt($pos2);
    switch (c) {
      case 91:
        state.pos++;
        state.ok = true;
        $2 = '[';
        break;
      case 93:
        state.pos++;
        state.ok = true;
        $2 = ']';
        break;
    }
  }
  if (!state.ok && state.log) {
    state.error = ErrCombined($pos2, [
      ErrExpected.tag(state.pos, Tag('[')),
      ErrExpected.tag(state.pos, Tag(']'))
    ]);
  }
  state.ok = !state.ok;
  if (state.ok) {
    $1 = true;
  } else {
    state.pos = $pos1;
    if ($log) {
      state.error = ErrUnknown(state.pos);
    }
  }
  state.log = $log;
  if (state.ok) {
    int? $3;
    state.ok = false;
    if (state.pos < source.length) {
      final pos = state.pos;
      var c = source.readRune(state);
      state.ok = c > 0x20 && c < 0x7f;
      if (state.ok) {
        $3 = c;
      } else {
        state.pos = pos;
        if (state.log) {
          state.error = ErrUnexpected.char(state.pos, Char(c));
        }
      }
    } else if (state.log) {
      state.error = ErrUnexpected.eof(state.pos);
    }
    if (state.ok) {
      $0 = $3!;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

int? _hexOrRangeChar(State<String> state) {
  int? $0;
  int? $1;
  $1 = _hex(state);
  if (state.ok) {
    $0 = $1!;
  } else {
    final $error = state.error;
    int? $2;
    $2 = _rangeChar(state);
    if (state.ok) {
      $0 = $2!;
    } else if (state.log) {
      state.error = ErrCombined(state.pos, [$error, state.error]);
    }
  }
  return $0;
}

Tuple2<int, int>? _rangeBody(State<String> state) {
  final source = state.source;
  Tuple2<int, int>? $0;
  for (;;) {
    Tuple2<int, int>? $1;
    final $pos = state.pos;
    int? $3;
    $3 = _hexOrRangeChar(state);
    if (state.ok) {
      String? $4;
      state.ok =
          state.pos < source.length && source.codeUnitAt(state.pos) == 45;
      if (state.ok) {
        state.pos++;
        $4 = '-';
      } else if (state.log) {
        state.error = ErrExpected.tag(state.pos, const Tag('-'));
      }
      if (state.ok) {
        int? $5;
        $5 = _hexOrRangeChar(state);
        if (state.ok) {
          $1 = Tuple2($3!, $5!);
        }
      }
    }
    if (!state.ok) {
      state.pos = $pos;
    }
    if (state.ok) {
      $0 = $1;
      break;
    }
    final $2 = state.error;
    Tuple2<int, int>? $6;
    int? $8;
    $8 = _hex(state);
    if (state.ok) {
      final v = $8!;
      $6 = Tuple2(v, v);
    }
    if (state.ok) {
      $0 = $6;
      break;
    }
    final $7 = state.error;
    Tuple2<int, int>? $9;
    int? $11;
    $11 = _rangeChar(state);
    if (state.ok) {
      final v = $11!;
      $9 = Tuple2(v, v);
    }
    if (state.ok) {
      $0 = $9;
      break;
    }
    final $10 = state.error;
    if (state.log) {
      state.error = ErrCombined(state.pos, [$2, $7, $10]);
    }
    break;
  }
  return $0;
}

int? _charCode(State<String> state) {
  final source = state.source;
  int? $0;
  state.ok = false;
  if (state.pos < source.length) {
    final pos = state.pos;
    var c = source.readRune(state);
    state.ok = c > 0x20 && c < 0x7f;
    if (state.ok) {
      $0 = c;
    } else {
      state.pos = pos;
      if (state.log) {
        state.error = ErrUnexpected.char(state.pos, Char(c));
      }
    }
  } else if (state.log) {
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
}

int? _char(State<String> state) {
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  String? $1;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 34;
  if (state.ok) {
    state.pos++;
    $1 = '"';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('"'));
  }
  if (state.ok) {
    int? $2;
    $2 = _charCode(state);
    if (state.ok) {
      String? $3;
      state.ok =
          state.pos < source.length && source.codeUnitAt(state.pos) == 34;
      if (state.ok) {
        state.pos++;
        $3 = '"';
      } else if (state.log) {
        state.error = ErrExpected.tag(state.pos, const Tag('"'));
      }
      if (state.ok) {
        $0 = $2!;
      }
    }
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
  String? $2;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 91;
  if (state.ok) {
    state.pos++;
    $2 = '[';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('['));
  }
  if (state.ok) {
    List<Tuple2<int, int>>? $3;
    final $log = state.log;
    final $list = <Tuple2<int, int>>[];
    for (;;) {
      state.log = $list.isEmpty;
      Tuple2<int, int>? $4;
      $4 = _rangeBody(state);
      if (!state.ok) {
        break;
      }
      $list.add($4!);
    }
    if ($list.isNotEmpty) {
      state.ok = true;
      $3 = $list;
    }
    state.log = $log;
    if (state.ok) {
      String? $5;
      state.ok =
          state.pos < source.length && source.codeUnitAt(state.pos) == 93;
      if (state.ok) {
        state.pos++;
        $5 = ']';
      } else if (state.log) {
        state.error = ErrExpected.tag(state.pos, const Tag(']'));
      }
      if (state.ok) {
        $1 = $3!;
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  if (state.ok) {
    $0 = $1!;
  } else {
    final $error = state.error;
    List<Tuple2<int, int>>? $6;
    int? $7;
    int? $8;
    $8 = _char(state);
    if (state.ok) {
      $7 = $8!;
    } else {
      final $error1 = state.error;
      int? $9;
      $9 = _hex(state);
      if (state.ok) {
        $7 = $9!;
      } else if (state.log) {
        state.error = ErrCombined(state.pos, [$error1, state.error]);
      }
    }
    if (state.ok) {
      final v = $7!;
      $6 = [Tuple2(v, v)];
    }
    if (state.ok) {
      $0 = $6!;
    } else if (state.log) {
      state.error = ErrCombined(state.pos, [$error, state.error]);
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
    state.pos++;
    $1 = '|';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('|'));
  }
  if (state.ok) {
    bool? $2;
    $2 = _ws(state);
    if (state.ok) {
      $0 = $1!;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

List<Tuple2<int, int>>? _ranges(State<String> state) {
  List<Tuple2<int, int>>? $0;
  List<List<Tuple2<int, int>>>? $1;
  final $log = state.log;
  var $pos = state.pos;
  final $list = <List<Tuple2<int, int>>>[];
  for (;;) {
    state.log = $list.isEmpty;
    List<Tuple2<int, int>>? $2;
    final $pos1 = state.pos;
    List<Tuple2<int, int>>? $3;
    $3 = _range(state);
    if (state.ok) {
      bool? $4;
      $4 = _ws(state);
      if (state.ok) {
        $2 = $3!;
      }
    }
    if (!state.ok) {
      state.pos = $pos1;
    }
    if (!state.ok) {
      state.pos = $pos;
      break;
    }
    $list.add($2!);
    $pos = state.pos;
    String? $5;
    $5 = _verbar(state);
    if (!state.ok) {
      break;
    }
  }
  if ($list.isNotEmpty) {
    state.ok = true;
    $1 = $list;
  }
  state.log = $log;
  if (state.ok) {
    final v = $1!;
    $0 = _flatten(v, <Tuple2<int, int>>[]);
  }
  return $0;
}

List<Tuple2<int, int>>? parse(State<String> state) {
  List<Tuple2<int, int>>? $0;
  final $pos = state.pos;
  bool? $1;
  $1 = _ws(state);
  if (state.ok) {
    List<Tuple2<int, int>>? $2;
    $2 = _ranges(state);
    if (state.ok) {
      bool? $3;
      state.ok = state.pos >= state.source.length;
      if (state.ok) {
        $3 = true;
      } else if (state.log) {
        state.error = ErrExpected.eof(state.pos);
      }
      if (state.ok) {
        $0 = $2!;
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
  @override
  int get hashCode => length.hashCode ^ offset.hashCode;

  int get length;

  int get offset;

  @override
  bool operator ==(other) {
    return other is Err && other.length == length && other.offset == offset;
  }

  static List<Err> errorReport(Err error) {
    var result = Err.flatten(error);
    result = Err.groupExpected(result);
    return result;
  }

  static List<Err> flatten(Err error) {
    void flatten(Err error, List<Err> result) {
      if (error is ErrCombined) {
        for (final error in error.errors) {
          flatten(error, result);
        }
      } else if (error is ErrWithTagAndErrors) {
        final inner = <Err>[];
        for (final nestedError in error.errors) {
          flatten(nestedError, inner);
        }

        int max(int x, int y) => x > y
            ? x
            : y < x
                ? x
                : y;
        final maxOffset = inner.map((e) => e.offset).reduce(max);
        final farthest = inner.where((e) => e.offset == maxOffset);
        final offset = error.offset;
        final tag = error.tag;
        result.add(ErrExpected.tag(offset, tag));
        if (maxOffset > offset) {
          if (error is ErrMalformed) {
            result
                .add(ErrMessage(offset, maxOffset - offset, 'Malformed $tag'));
            result.addAll(farthest);
          } else if (error is ErrNested) {
            result.addAll(farthest);
          } else {
            throw StateError('Internal error');
          }
        }
      } else {
        result.add(error);
      }
    }

    final result = <Err>[];
    flatten(error, result);
    return result.toSet().toList();
  }

  static List<Err> groupExpected(List<Err> errors) {
    final result = <Err>[];
    final expected = errors.whereType<ErrExpected>();
    Map<T, List<S>> groupBy<S, T>(Iterable<S> values, T Function(S) key) {
      final map = <T, List<S>>{};
      for (final element in values) {
        (map[key(element)] ??= []).add(element);
      }
      return map;
    }

    final groupped = groupBy(expected, (Err e) => e.offset);
    final offsets = <int>{};
    final processed = <Err>{};
    for (final error in errors) {
      if (!processed.add(error)) {
        continue;
      }

      if (error is! ErrExpected) {
        result.add(error);
        continue;
      }

      final offset = error.offset;
      if (!offsets.add(offset)) {
        continue;
      }

      final elements = <String>[];
      for (final error in groupped[offset]!) {
        elements.add(error.value.toString());
        processed.add(error);
      }

      final message = elements.join(', ');
      final newError = ErrMessage(offset, 1, 'Expected: $message');
      result.add(newError);
    }

    return result;
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
  int get length => 1;

  @override
  String toString() {
    final result = 'Expected: $value';
    return result;
  }
}

class ErrMalformed extends ErrWithTagAndErrors {
  @override
  final List<Err> errors;

  @override
  final int offset;

  @override
  final Tag tag;

  ErrMalformed(this.offset, this.tag, this.errors);

  @override
  int get length => 1;

  @override
  String toString() {
    final result = 'Malformed $tag';
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
  String toString() {
    return message;
  }
}

class ErrNested extends ErrWithTagAndErrors {
  @override
  final List<Err> errors;

  @override
  final int offset;

  @override
  final Tag tag;

  ErrNested(this.offset, this.tag, this.errors);

  @override
  int get length => 1;

  @override
  String toString() {
    final result = 'Nested $tag';
    return result;
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
  String toString() {
    final result = 'Unknown error';
    return result;
  }
}

abstract class ErrWithErrors extends Err {
  List<Err> get errors;

  @override
  String toString() {
    final list = errors.join(', ');
    final result = '[$list]';
    return result;
  }
}

abstract class ErrWithTagAndErrors extends ErrWithErrors {
  Tag get tag;
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

    return '\'$s\'';
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
