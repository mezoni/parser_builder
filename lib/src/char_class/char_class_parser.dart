// ignore_for_file: unnecessary_cast

import 'package:source_span/source_span.dart';
import 'package:tuple/tuple.dart';

List<Tuple2<int, int>> parseString(String source) {
  final state = State(source);
  final result = parse(state);
  if (!state.ok) {
    final errors = ParseError.errorReport(state.errors);
    final message = _errorMessage(source, errors);
    throw FormatException('\n$message');
  }

  return result!;
}

void _ws(State<String> state) {
  final source = state.source;
  while (state.pos < source.length) {
    final pos = state.pos;
    final c = source.readRune(state);
    final ok = c == 0x09 || c == 0xA || c == 0xD || c == 0x20;
    if (!ok) {
      state.pos = pos;
      break;
    }
  }
  state.ok = true;
}

int? _hexVal(State<String> state) {
  int? $0;
  final source = state.source;
  String? $1;
  final $pos = state.pos;
  int? $c;
  while (state.pos < source.length) {
    final pos = state.pos;
    $c = source.readRune(state);
    final ok = $c >= 0x30 && $c <= 0x39 ||
        $c >= 0x41 && $c <= 0x46 ||
        $c >= 0x61 && $c <= 0x66;
    if (!ok) {
      state.pos = pos;
      break;
    }
  }
  state.ok = state.pos != $pos;
  if (state.ok) {
    $1 = source.substring($pos, state.pos);
  } else {
    if ($pos < source.length) {
      state.error = ParseError.unexpected($pos, 0, $c!);
    } else {
      state.error = ParseError.unexpected($pos, 0, 'EOF');
    }
  }
  if (state.ok) {
    final v = $1!;
    $0 = _toHexValue(v);
  }
  return $0;
}

int? _hex(State<String> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos + 1 < source.length &&
      source.codeUnitAt(state.pos) == 35 &&
      source.codeUnitAt(state.pos + 1) == 120;
  if (state.ok) {
    state.pos += 2;
  } else {
    state.error = ParseError.expected(state.pos, '#x');
  }
  if (state.ok) {
    $0 = _hexVal(state);
  }
  if (!state.ok) {
    $0 = null;
    state.pos = $pos;
  }
  return $0;
}

int? _rangeChar(State<String> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  final $pos1 = state.pos;
  state.errorPos = 0x7fffffff;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final pos = state.pos;
    final c = source.codeUnitAt(pos);
    String? v;
    switch (c) {
      case 91:
        state.pos++;
        v = '[';
        break;
      case 93:
        state.pos++;
        v = ']';
        break;
    }
    state.ok = v != null;
  }
  if (!state.ok) {
    state.error = ParseError.expected(state.pos, '[');
    state.error = ParseError.expected(state.pos, ']');
  }
  state.restoreErrorPos();
  state.ok = !state.ok;
  if (!state.ok) {
    state.pos = $pos1;
    state.error = ParseError.message(state.pos, 0, 'Unknown error');
  }
  if (state.ok) {
    state.ok = state.pos < source.length;
    if (state.ok) {
      final pos = state.pos;
      final c = source.readRune(state);
      state.ok = c >= 0x20 && c < 0x7f;
      if (state.ok) {
        $0 = c;
      } else {
        state.pos = pos;
        state.error = ParseError.unexpected(state.pos, 0, c);
      }
    } else {
      state.error = ParseError.unexpected(state.pos, 0, 'EOF');
    }
  }
  if (!state.ok) {
    $0 = null;
    state.pos = $pos;
  }
  return $0;
}

int? _hexOrRangeChar(State<String> state) {
  int? $0;
  $0 = _hex(state);
  if (!state.ok) {
    $0 = _rangeChar(state);
  }
  return $0;
}

Tuple2<int, int>? _rangeBody(State<String> state) {
  Tuple2<int, int>? $0;
  final source = state.source;
  final $pos = state.pos;
  int? $1;
  $1 = _hexOrRangeChar(state);
  if (state.ok) {
    state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 45;
    if (state.ok) {
      state.pos += 1;
    } else {
      state.error = ParseError.expected(state.pos, '-');
    }
    if (state.ok) {
      int? $2;
      $2 = _hexOrRangeChar(state);
      if (state.ok) {
        $0 = Tuple2($1!, $2!);
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  if (!state.ok) {
    int? $3;
    $3 = _hex(state);
    if (state.ok) {
      final v = $3!;
      $0 = Tuple2(v, v);
    }
    if (!state.ok) {
      int? $4;
      $4 = _rangeChar(state);
      if (state.ok) {
        final v = $4!;
        $0 = Tuple2(v, v);
      }
    }
  }
  return $0;
}

int? _charCode(State<String> state) {
  int? $0;
  final source = state.source;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final pos = state.pos;
    final c = source.readRune(state);
    state.ok = c >= 0x20 && c < 0x7f;
    if (state.ok) {
      $0 = c;
    } else {
      state.pos = pos;
      state.error = ParseError.unexpected(state.pos, 0, c);
    }
  } else {
    state.error = ParseError.unexpected(state.pos, 0, 'EOF');
  }
  return $0;
}

int? _char(State<String> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 34;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.error = ParseError.expected(state.pos, '"');
  }
  if (state.ok) {
    $0 = _charCode(state);
    if (state.ok) {
      state.ok =
          state.pos < source.length && source.codeUnitAt(state.pos) == 34;
      if (state.ok) {
        state.pos += 1;
      } else {
        state.error = ParseError.expected(state.pos, '"');
      }
    }
  }
  if (!state.ok) {
    $0 = null;
    state.pos = $pos;
  }
  return $0;
}

List<Tuple2<int, int>>? _range(State<String> state) {
  List<Tuple2<int, int>>? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 91;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.error = ParseError.expected(state.pos, '[');
  }
  if (state.ok) {
    var $list = <Tuple2<int, int>>[];
    while (true) {
      Tuple2<int, int>? $1;
      $1 = _rangeBody(state);
      if (!state.ok) {
        break;
      }
      $list.add($1!);
    }
    state.ok = $list.isNotEmpty;
    if (state.ok) {
      $0 = $list;
    }
    if (state.ok) {
      state.ok =
          state.pos < source.length && source.codeUnitAt(state.pos) == 93;
      if (state.ok) {
        state.pos += 1;
      } else {
        state.error = ParseError.expected(state.pos, ']');
      }
    }
  }
  if (!state.ok) {
    $0 = null;
    state.pos = $pos;
  }
  if (!state.ok) {
    int? $2;
    $2 = _char(state);
    if (!state.ok) {
      $2 = _hex(state);
    }
    if (state.ok) {
      final v = $2!;
      $0 = [Tuple2(v, v)];
    }
  }
  return $0;
}

void _verbar(State<String> state) {
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 124;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.error = ParseError.expected(state.pos, '|');
  }
  if (state.ok) {
    _ws(state);
  }
  if (!state.ok) {
    state.pos = $pos;
  }
}

List<Tuple2<int, int>>? _ranges(State<String> state) {
  List<Tuple2<int, int>>? $0;
  List<List<Tuple2<int, int>>>? $1;
  var $pos = state.pos;
  final $list = <List<Tuple2<int, int>>>[];
  while (true) {
    List<Tuple2<int, int>>? $2;
    final $pos1 = state.pos;
    $2 = _range(state);
    if (state.ok) {
      _ws(state);
    }
    if (!state.ok) {
      $2 = null;
      state.pos = $pos1;
    }
    if (!state.ok) {
      state.pos = $pos;
      break;
    }
    $list.add($2!);
    $pos = state.pos;
    _verbar(state);
    if (!state.ok) {
      break;
    }
  }
  state.ok = $list.isNotEmpty;
  if (state.ok) {
    $1 = $list;
  }
  if (state.ok) {
    final v = $1!;
    $0 = _flatten(v, <Tuple2<int, int>>[]);
  }
  return $0;
}

List<Tuple2<int, int>>? parse(State<String> state) {
  List<Tuple2<int, int>>? $0;
  final source = state.source;
  final $pos = state.pos;
  _ws(state);
  if (state.ok) {
    $0 = _ranges(state);
    if (state.ok) {
      state.ok = state.pos >= source.length;
      if (!state.ok) {
        state.error = ParseError.expected(state.pos, 'EOF');
      }
    }
  }
  if (!state.ok) {
    $0 = null;
    state.pos = $pos;
  }
  return $0;
}

String _errorMessage(String source, List<ParseError> errors,
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

class ParseError {
  final ParseErrorKind kind;

  final int length;

  final int offset;

  final Object? value;

  ParseError.expected(this.offset, this.value)
      : kind = ParseErrorKind.expected,
        length = 0;

  ParseError.message(this.offset, this.length, String message)
      : kind = ParseErrorKind.message,
        value = message;

  ParseError.unexpected(this.offset, this.length, this.value)
      : kind = ParseErrorKind.unexpected;

  ParseError._(this.kind, this.offset, this.length, this.value);

  @override
  int get hashCode =>
      kind.hashCode ^ length.hashCode ^ offset.hashCode ^ value.hashCode;

  @override
  bool operator ==(other) {
    return other is ParseError &&
        other.kind == kind &&
        other.length == length &&
        other.offset == offset &&
        other.value == value;
  }

  ParseError normalize() {
    if (length >= 0) {
      return this;
    }

    return ParseError._(kind, offset + length, -length, value);
  }

  @override
  String toString() {
    switch (kind) {
      case ParseErrorKind.expected:
        return 'Expected: $value';
      case ParseErrorKind.message:
        return '$value';
      case ParseErrorKind.unexpected:
        return 'Unexpected: $value';
    }
  }

  static List<ParseError> errorReport(List<ParseError> errors) {
    errors = errors.toSet().map((e) => e.normalize()).toList();
    final grouped = <int, List<ParseError>>{};
    final expected = errors.where((e) => e.kind == ParseErrorKind.expected);
    for (final error in expected) {
      final offset = error.offset;
      var list = grouped[offset];
      if (list == null) {
        list = [];
        grouped[offset] = list;
      }

      list.add(error);
    }

    final result = <ParseError>[];
    for (final key in grouped.keys) {
      final list = grouped[key]!;
      final values = list.map((e) => '\'${_escape(e.value)}\'').join(', ');
      result.add(ParseError.message(key, 0, 'Expected: $values'));
    }

    for (var i = 0; i < errors.length; i++) {
      var error = errors[i];
      if (error.kind != ParseErrorKind.expected) {
        if (error.kind == ParseErrorKind.unexpected) {
          error = ParseError.unexpected(
              error.offset, error.length, '\'${_escape(error.value)}\'');
        }
        result.add(error);
      }
    }

    return result;
  }

  static String _escape(value) {
    if (value is int) {
      if (value >= 0 && value <= 0xd7ff ||
          value >= 0xe000 && value <= 0x10ffff) {
        value = String.fromCharCode(value);
      } else {
        return value.toString();
      }
    } else if (value is! String) {
      return value.toString();
    }

    final map = {
      '\b': '\\b',
      '\f': '\\f',
      '\n': '\\n',
      '\r': '\\t',
      '\t': '\\t',
      '\v': '\\v',
    };
    var result = value.toString();
    for (final key in map.keys) {
      result = result.replaceAll(key, map[key]!);
    }

    return result;
  }
}

enum ParseErrorKind { expected, message, unexpected }

class State<T> {
  dynamic context;

  int errorPos = -1;

  int newErrorPos = -1;

  bool ok = false;

  int pos = 0;

  final T source;

  final List<ParseError?> _errors = List.filled(500, null);

  int _length = 0;

  final List<_Memo> _memos = [];

  State(this.source);

  set error(ParseError error) {
    final offset = error.offset;
    if (offset >= errorPos) {
      if (offset > errorPos) {
        errorPos = offset;
        _length = 0;
      }
      newErrorPos = offset;
      _errors[_length++] = error;
    }
  }

  List<ParseError> get errors {
    return List.generate(_length, (i) => _errors[i]!);
  }

  @pragma('vm:prefer-inline')
  void memoize<R>(int id, bool fast, int start, [R? result]) {
    final memo = _Memo(id, fast, start, pos, ok, result);
    var found = false;
    for (var i = 0; i < _memos.length; i++) {
      if (_memos[i].id == id) {
        found = true;
        _memos[i] = memo;
        break;
      }
    }

    if (!found) {
      _memos.add(memo);
    }
  }

  @pragma('vm:prefer-inline')
  _Memo<R>? memoized<R>(int id, bool fast, int start) {
    for (var i = 0; i < _memos.length; i++) {
      final memo = _memos[i];
      if (memo.id == id) {
        if (memo.canRestore(start, fast)) {
          return memo as _Memo<R>;
        }

        break;
      }
    }

    return null;
  }

  @pragma('vm:prefer-inline')
  void restoreErrorPos() {
    errorPos = _length == 0 ? -1 : _errors[0]!.offset;
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
}

class _Memo<T> {
  final int end;

  final bool fast;

  final int id;

  final bool ok;

  final T? result;

  final int start;

  _Memo(this.id, this.fast, this.start, this.end, this.ok, this.result);

  @pragma('vm:prefer-inline')
  bool canRestore(int start, bool fast) {
    return this.start == start && (this.fast == fast || !this.fast);
  }

  @pragma('vm:prefer-inline')
  T? restore(State state) {
    state.ok = ok;
    state.pos = end;
    return result;
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
