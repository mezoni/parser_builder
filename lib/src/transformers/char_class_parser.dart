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
  bool? $0;
  bool $test(int x) => x == 0x09 || x == 0xA || x == 0xD || x == 0x20;
  while (state.ch != State.eof && $test(state.ch)) {
    state.nextChar();
  }
  state.ok = true;
  if (state.ok) {
    $0 = true;
  }
  return $0;
}

int? _hexVal(State<String> state) {
  int? $0;
  String? $1;
  state.ok = false;
  final $pos = state.pos;
  bool $test(int x) =>
      x >= 0x30 && x <= 0x39 ||
      x >= 0x41 && x <= 0x46 ||
      x >= 0x61 && x <= 0x66;
  while (state.ch != State.eof && $test(state.ch)) {
    state.nextChar();
    state.ok = true;
  }
  if (state.ok) {
    $1 = state.source.substring($pos, state.pos);
  } else {
    state.error = state.ch == State.eof
        ? ErrUnexpected.eof(state.pos)
        : ErrUnexpected.char(state.pos, Char(state.ch));
  }
  if (state.ok) {
    int map(String x) => _toHexValue(x);
    $0 = map($1!);
  }
  return $0;
}

int? _hex(State<String> state) {
  int? $0;
  final $pos = state.pos;
  final $ch = state.ch;
  String? $1;
  state.ok = state.ch == 35 && state.source.startsWith('#x', state.pos);
  if (state.ok) {
    state.readChar(state.pos + 2);
    $1 = '#x';
  } else {
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
    state.ch = $ch;
  }
  return $0;
}

int? _rangeChar(State<String> state) {
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  final $ch = state.ch;
  bool? $1;
  final $pos1 = state.pos;
  String? $2;
  state.ok = true;
  switch (state.ch) {
    case 91:
      if (source.startsWith('[', state.pos)) {
        state.readChar(state.pos + 1);
        $2 = '[';
        break;
      }
      break;
    case 93:
      if (source.startsWith(']', state.pos)) {
        state.readChar(state.pos + 1);
        $2 = ']';
        break;
      }
      break;
  }
  if ($2 == null) {
    state.ok = false;
    state.error = ErrCombined(state.pos, [
      ErrExpected.tag(state.pos, Tag('[')),
      ErrExpected.tag(state.pos, Tag(']'))
    ]);
  }
  if (!state.ok) {
    state.ok = true;
    $1 = true;
  } else {
    state.pos = $pos1;
    state.ok = false;
    state.error = ErrUnknown(state.pos);
  }
  if (state.ok) {
    int? $3;
    bool $test(int x) => x > 0x20 && x < 0x7f;
    state.ok = state.ch != State.eof && $test(state.ch);
    if (state.ok) {
      $3 = state.ch;
      state.nextChar();
    } else {
      state.error = state.ch == State.eof
          ? ErrUnexpected.eof(state.pos)
          : ErrUnexpected.char(state.pos, Char(state.ch));
    }
    if (state.ok) {
      $0 = $3!;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.ch = $ch;
  }
  return $0;
}

int? _hexOrRangeChar(State<String> state) {
  int? $0;
  for (;;) {
    int? $1;
    $1 = _hex(state);
    if (state.ok) {
      $0 = $1;
      break;
    }
    final $2 = state.error;
    int? $3;
    $3 = _rangeChar(state);
    if (state.ok) {
      $0 = $3;
      break;
    }
    final $4 = state.error;
    state.error = ErrCombined(state.pos, [$2, $4]);
    break;
  }
  return $0;
}

Tuple2<int, int>? _rangeBody(State<String> state) {
  Tuple2<int, int>? $0;
  for (;;) {
    Tuple2<int, int>? $1;
    final $pos = state.pos;
    final $ch = state.ch;
    int? $3;
    $3 = _hexOrRangeChar(state);
    if (state.ok) {
      String? $4;
      state.ok = state.ch == 45;
      if (state.ok) {
        state.nextChar();
        $4 = '-';
      } else {
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
      state.ch = $ch;
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
      Tuple2<int, int> map(int x) => Tuple2(x, x);
      $6 = map($8!);
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
      Tuple2<int, int> map(int x) => Tuple2(x, x);
      $9 = map($11!);
    }
    if (state.ok) {
      $0 = $9;
      break;
    }
    final $10 = state.error;
    state.error = ErrCombined(state.pos, [$2, $7, $10]);
    break;
  }
  return $0;
}

int? _charCode(State<String> state) {
  int? $0;
  bool $test(int x) => x > 0x20 && x < 0x7f;
  state.ok = state.ch != State.eof && $test(state.ch);
  if (state.ok) {
    $0 = state.ch;
    state.nextChar();
  } else {
    state.error = state.ch == State.eof
        ? ErrUnexpected.eof(state.pos)
        : ErrUnexpected.char(state.pos, Char(state.ch));
  }
  return $0;
}

int? _char(State<String> state) {
  int? $0;
  final $pos = state.pos;
  final $ch = state.ch;
  String? $1;
  state.ok = state.ch == 34;
  if (state.ok) {
    state.nextChar();
    $1 = '"';
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('"'));
  }
  if (state.ok) {
    int? $2;
    $2 = _charCode(state);
    if (state.ok) {
      String? $3;
      state.ok = state.ch == 34;
      if (state.ok) {
        state.nextChar();
        $3 = '"';
      } else {
        state.error = ErrExpected.tag(state.pos, const Tag('"'));
      }
      if (state.ok) {
        $0 = $2!;
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.ch = $ch;
  }
  return $0;
}

List<Tuple2<int, int>>? _range(State<String> state) {
  List<Tuple2<int, int>>? $0;
  for (;;) {
    List<Tuple2<int, int>>? $1;
    final $pos = state.pos;
    final $ch = state.ch;
    String? $3;
    state.ok = state.ch == 91;
    if (state.ok) {
      state.nextChar();
      $3 = '[';
    } else {
      state.error = ErrExpected.tag(state.pos, const Tag('['));
    }
    if (state.ok) {
      List<Tuple2<int, int>>? $4;
      final $list = <Tuple2<int, int>>[];
      for (;;) {
        Tuple2<int, int>? $5;
        $5 = _rangeBody(state);
        if (!state.ok) {
          if ($list.isNotEmpty) {
            state.ok = true;
            $4 = $list;
          }
          break;
        }
        $list.add($5!);
      }
      if (state.ok) {
        String? $6;
        state.ok = state.ch == 93;
        if (state.ok) {
          state.nextChar();
          $6 = ']';
        } else {
          state.error = ErrExpected.tag(state.pos, const Tag(']'));
        }
        if (state.ok) {
          $1 = $4!;
        }
      }
    }
    if (!state.ok) {
      state.pos = $pos;
      state.ch = $ch;
    }
    if (state.ok) {
      $0 = $1;
      break;
    }
    final $2 = state.error;
    List<Tuple2<int, int>>? $7;
    int? $9;
    for (;;) {
      int? $10;
      $10 = _char(state);
      if (state.ok) {
        $9 = $10;
        break;
      }
      final $11 = state.error;
      int? $12;
      $12 = _hex(state);
      if (state.ok) {
        $9 = $12;
        break;
      }
      final $13 = state.error;
      state.error = ErrCombined(state.pos, [$11, $13]);
      break;
    }
    if (state.ok) {
      List<Tuple2<int, int>> map(dynamic x) => [Tuple2(x, x)];
      $7 = map($9!);
    }
    if (state.ok) {
      $0 = $7;
      break;
    }
    final $8 = state.error;
    state.error = ErrCombined(state.pos, [$2, $8]);
    break;
  }
  return $0;
}

String? _verbar(State<String> state) {
  String? $0;
  final $pos = state.pos;
  final $ch = state.ch;
  String? $1;
  state.ok = state.ch == 124;
  if (state.ok) {
    state.nextChar();
    $1 = '|';
  } else {
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
    state.ch = $ch;
  }
  return $0;
}

List<Tuple2<int, int>>? _ranges(State<String> state) {
  List<Tuple2<int, int>>? $0;
  List<List<Tuple2<int, int>>>? $1;
  var $pos = state.pos;
  var $ch = state.ch;
  final $list = <List<Tuple2<int, int>>>[];
  for (;;) {
    List<Tuple2<int, int>>? $2;
    final $pos1 = state.pos;
    final $ch1 = state.ch;
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
      state.ch = $ch1;
    }
    if (!state.ok) {
      state.pos = $pos;
      state.ch = $ch;
      break;
    }
    $list.add($2!);
    $pos = state.pos;
    $ch = state.ch;
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
  if (state.ok) {
    List<Tuple2<int, int>> map(List<List<Tuple2<int, int>>> x) =>
        _flatten(x, <Tuple2<int, int>>[]);
    $0 = map($1!);
  }
  return $0;
}

List<Tuple2<int, int>>? parse(State<String> state) {
  List<Tuple2<int, int>>? $0;
  final $pos = state.pos;
  final $ch = state.ch;
  bool? $1;
  $1 = _ws(state);
  if (state.ok) {
    List<Tuple2<int, int>>? $2;
    $2 = _ranges(state);
    if (state.ok) {
      bool? $3;
      state.ok = state.source.atEnd(state.pos);
      if (state.ok) {
        $3 = true;
      } else {
        state.error = ErrExpected.eof(state.pos);
      }
      if (state.ok) {
        $0 = $2!;
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.ch = $ch;
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
    final s = String.fromCharCode(charCode);
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
  static const eof = 0x110000;

  dynamic context;

  int ch = eof;

  Err error = ErrUnknown(0);

  bool ok = false;

  int pos = 0;

  final T source;

  State(this.source) {
    if (this is State<String>) {
      final this_ = this as State<String>;
      ch = this_.getChar(0);
    }
  }

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
    return name;
  }
}

extension on State<String> {
  @pragma('vm:prefer-inline')
  int getChar(int index) {
    if (index < source.length) {
      final c = source.codeUnitAt(index++);
      return c <= 0xD7FF || c >= 0xE000 ? c : _getChar32(c, index);
    }
    return State.eof;
  }

  @pragma('vm:prefer-inline')
  // ignore: unused_element
  int nextChar() {
    final index = pos + (ch > 0xffff ? 2 : 1);
    if (index < source.length) {
      pos = index;
      ch = getChar(index);
    } else {
      pos = source.length;
      ch = State.eof;
    }
    return ch;
  }

  @pragma('vm:prefer-inline')
  // ignore: unused_element
  int readChar(int index) {
    ch = getChar(index);
    pos = index < source.length ? index : source.length;
    return ch;
  }

  @pragma('vm:prefer-inline')
  int _getChar32(int c, int index) {
    if (index < source.length) {
      final c2 = source.codeUnitAt(index);
      if ((c2 & 0xfc00) == 0xdc00) {
        return 0x10000 + ((c & 0x3ff) << 10) + (c2 & 0x3ff);
      }
    }
    return State.eof;
  }
}

extension on String {
  /// Returns `true` if [pos] points to the end of the string (or beyond).
  @pragma('vm:prefer-inline')
  // ignore: unused_element
  bool atEnd(int pos) {
    return pos >= length;
  }

  /// Returns a slice (substring) of the string from [start] to [end].
  @pragma('vm:prefer-inline')
  // ignore: unused_element
  String slice(int start, int end) {
    return substring(start, end);
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
