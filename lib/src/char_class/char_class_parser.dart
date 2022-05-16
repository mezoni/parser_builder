import 'package:source_span/source_span.dart';

List<Result2<int, int>> parseString(String source) {
  final state = State(source);
  final result = parse(state);
  if (!state.ok) {
    final message = _errorMessage(source, state.errors);
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
  while (state.pos < source.length) {
    final pos = state.pos;
    final c = source.readRune(state);
    final ok = c >= 0x30 && c <= 0x39 ||
        c >= 0x41 && c <= 0x46 ||
        c >= 0x61 && c <= 0x66;
    if (!ok) {
      state.pos = pos;
      break;
    }
  }
  state.ok = state.pos != $pos;
  if (state.ok) {
    $1 = source.substring($pos, state.pos);
  } else {
    state.fail($pos, ParseError.character, 0, 0);
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
    state.fail(state.pos, ParseError.expected, 0, '#x');
  }
  if (state.ok) {
    $0 = _hexVal(state);
    if (!state.ok) {
      state.pos = $pos;
    }
  }
  return $0;
}

int? _rangeChar(State<String> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  final $pos1 = state.pos;
  final $log = state.log;
  state.log = false;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final pos = state.pos;
    final c = source.codeUnitAt(pos);
    String? v;
    if (c == 91) {
      state.pos++;
      v = '[';
    } else if (c == 93) {
      state.pos++;
      v = ']';
    }
    state.ok = v != null;
  }
  if (!state.ok) {
    state.fail(state.pos, ParseError.expected, 0, '[');
    state.fail(state.pos, ParseError.expected, 0, ']');
  }
  state.log = $log;
  state.ok = !state.ok;
  if (!state.ok) {
    state.pos = $pos1;
    state.fail(state.pos, ParseError.message, 0, 'Unknown error');
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
        state.fail(state.pos, ParseError.character, 0, c);
      }
    } else {
      state.fail(state.pos, ParseError.character, 0, 0);
    }
    if (!state.ok) {
      state.pos = $pos;
    }
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

Result2<int, int>? _rangeBody(State<String> state) {
  Result2<int, int>? $0;
  final source = state.source;
  final $pos = state.pos;
  int? $1;
  $1 = _hexOrRangeChar(state);
  if (state.ok) {
    state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 45;
    if (state.ok) {
      state.pos += 1;
    } else {
      state.fail(state.pos, ParseError.expected, 0, '-');
    }
    if (state.ok) {
      int? $2;
      $2 = _hexOrRangeChar(state);
      if (state.ok) {
        $0 = Result2($1!, $2!);
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
      $0 = Result2(v, v);
    }
    if (!state.ok) {
      int? $4;
      $4 = _rangeChar(state);
      if (state.ok) {
        final v = $4!;
        $0 = Result2(v, v);
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
      state.fail(state.pos, ParseError.character, 0, c);
    }
  } else {
    state.fail(state.pos, ParseError.character, 0, 0);
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
    state.fail(state.pos, ParseError.expected, 0, '"');
  }
  if (state.ok) {
    $0 = _charCode(state);
    if (state.ok) {
      state.ok =
          state.pos < source.length && source.codeUnitAt(state.pos) == 34;
      if (state.ok) {
        state.pos += 1;
      } else {
        state.fail(state.pos, ParseError.expected, 0, '"');
      }
    }
    if (!state.ok) {
      $0 = null;
      state.pos = $pos;
    }
  }
  return $0;
}

List<Result2<int, int>>? _range(State<String> state) {
  List<Result2<int, int>>? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 91;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.fail(state.pos, ParseError.expected, 0, '[');
  }
  if (state.ok) {
    var $list = <Result2<int, int>>[];
    while (true) {
      Result2<int, int>? $1;
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
        state.fail(state.pos, ParseError.expected, 0, ']');
      }
    }
    if (!state.ok) {
      $0 = null;
      state.pos = $pos;
    }
  }
  if (!state.ok) {
    int? $2;
    $2 = _char(state);
    if (!state.ok) {
      $2 = _hex(state);
    }
    if (state.ok) {
      final v = $2!;
      $0 = [Result2(v, v)];
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
    state.fail(state.pos, ParseError.expected, 0, '|');
  }
  if (state.ok) {
    _ws(state);
    if (!state.ok) {
      state.pos = $pos;
    }
  }
}

List<Result2<int, int>>? _ranges(State<String> state) {
  List<Result2<int, int>>? $0;
  List<List<Result2<int, int>>>? $1;
  var $pos = state.pos;
  final $list = <List<Result2<int, int>>>[];
  while (true) {
    List<Result2<int, int>>? $2;
    final $pos1 = state.pos;
    $2 = _range(state);
    if (state.ok) {
      _ws(state);
      if (!state.ok) {
        $2 = null;
        state.pos = $pos1;
      }
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
    $0 = _flatten(v, <Result2<int, int>>[]);
  }
  return $0;
}

List<Result2<int, int>>? parse(State<String> state) {
  List<Result2<int, int>>? $0;
  final source = state.source;
  final $pos = state.pos;
  _ws(state);
  if (state.ok) {
    $0 = _ranges(state);
    if (state.ok) {
      state.ok = state.pos >= source.length;
      if (!state.ok) {
        state.fail(state.pos, ParseError.expected, 0, 'EOF');
      }
    }
    if (!state.ok) {
      $0 = null;
      state.pos = $pos;
    }
  }
  return $0;
}

String _errorMessage(String source, List<ParseError> errors,
    [Object? color, int maxCount = 10, String? url]) {
  final sb = StringBuffer();
  for (var i = 0; i < errors.length; i++) {
    if (i > maxCount) {
      break;
    }

    final error = errors[i];
    final start = error.start;
    final end = error.end + 1;
    if (end > source.length) {
      source += ' ' * (end - source.length);
    }

    final file = SourceFile.fromString(source, url: url);
    final span = file.span(start, end);
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

class Result2<T0, T1> {
  final T0 $0;
  final T1 $1;

  Result2(this.$0, this.$1);

  @override
  int get hashCode => $0.hashCode ^ $1.hashCode;

  @override
  bool operator ==(other) =>
      other is Result2 && other.$0 == $0 && other.$1 == $1;
}

class ParseError {
  static const character = 0;

  static const expected = 1;

  static const message = 2;

  static const unexpected = 3;

  final int end;

  final int start;

  final String text;

  ParseError(this.start, this.end, this.text);

  @override
  int get hashCode => end.hashCode ^ start.hashCode ^ text.hashCode;

  @override
  bool operator ==(other) =>
      other is ParseError &&
      other.end == end &&
      other.start == start &&
      other.text == text;

  @override
  String toString() {
    return text;
  }
}

class State<T> {
  dynamic context;

  int errorPos = -1;

  int lastErrorPos = -1;

  int minErrorPos = -1;

  bool log = true;

  bool ok = false;

  int pos = 0;

  final T source;

  final List<int> _kinds = List.filled(150, 0);

  int _length = 0;

  final List<int> _lengths = List.filled(150, 0);

  final List<_Memo?> _memos = List.filled(150, null);

  final List<int> _starts = List.filled(150, 0);

  final List<Object?> _values = List.filled(150, null);

  State(this.source);

  List<ParseError> get errors => _buildErrors();

  @pragma('vm:prefer-inline')
  void fail(int pos, int kind, int length, Object? value, [int start = -1]) {
    if (log) {
      if (errorPos <= pos && minErrorPos <= pos) {
        if (errorPos < pos) {
          errorPos = pos;
          _length = 0;
        }

        _kinds[_length] = kind;
        _lengths[_length] = length;
        _starts[_length] = start;
        _values[_length] = value;
        _length++;
      }

      if (lastErrorPos < pos) {
        lastErrorPos = pos;
      }
    }
  }

  @pragma('vm:prefer-inline')
  void memoize<R>(int id, bool fast, int start, [R? result]) =>
      _memos[id] = _Memo<R>(id, fast, start, pos, ok, result);

  @pragma('vm:prefer-inline')
  _Memo<R>? memoized<R>(int id, bool fast, int start) {
    final memo = _memos[id];
    return (memo != null &&
            memo.start == start &&
            (memo.fast == fast || !memo.fast))
        ? memo as _Memo<R>
        : null;
  }

  @pragma('vm:prefer-inline')
  void restoreLastErrorPos(int pos) {
    if (lastErrorPos < pos) {
      lastErrorPos = pos;
    }
  }

  @pragma('vm:prefer-inline')
  int setLastErrorPos(int pos) {
    final result = lastErrorPos;
    lastErrorPos = pos;
    return result;
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

  List<ParseError> _buildErrors() {
    final result = <ParseError>[];
    final expected = <String>[];
    for (var i = 0; i < _length; i++) {
      final kind = _kinds[i];
      if (kind == ParseError.expected) {
        final value = _values[i];
        final escaped = _escape(value);
        expected.add(escaped);
      }
    }

    if (expected.isNotEmpty) {
      final text = 'Expected: ${expected.toSet().join(', ')}';
      final error = ParseError(errorPos, errorPos, text);
      result.add(error);
    }

    for (var i = 0; i < _length; i++) {
      final kind = _kinds[i];
      final length = _lengths[i];
      var value = _values[i];
      var start = _starts[i];
      if (start < 0) {
        start = errorPos;
      }

      final end = start + (length > 0 ? length - 1 : 0);
      switch (kind) {
        case ParseError.character:
          if (source is String) {
            final string = source as String;
            if (start < string.length) {
              value = string.runeAt(errorPos);
              final escaped = _escape(value);
              final error =
                  ParseError(errorPos, errorPos, 'Unexpected $escaped');
              result.add(error);
            } else {
              final error = ParseError(errorPos, errorPos, "Unexpected 'EOF'");
              result.add(error);
            }
          } else {
            final error =
                ParseError(errorPos, errorPos, 'Unexpected character');
            result.add(error);
          }

          break;
        case ParseError.expected:
          break;
        case ParseError.message:
          final error = ParseError(start, end, '$value');
          result.add(error);
          break;
        case ParseError.unexpected:
          final escaped = _escape(value);
          final error = ParseError(start, end, 'Unexpected $escaped');
          result.add(error);
          break;
        default:
          final error = ParseError(start, end, '$value');
          result.add(error);
      }
    }

    return result.toSet().toList();
  }

  String _escape(Object? value, [bool quote = true]) {
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
      '\r': '\\r',
      '\t': '\\t',
      '\v': '\\v',
    };
    var result = value.toString();
    for (final key in map.keys) {
      result = result.replaceAll(key, map[key]!);
    }

    if (quote) {
      result = "'$result'";
    }

    return result;
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
