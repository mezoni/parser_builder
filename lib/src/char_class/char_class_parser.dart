List<Result2<int, int>> parseSource(Utf16Reader source) {
  final state = State(source);
  final result = parse(state);
  if (!state.ok) {
    final message = _errorMessage(source, state.errors);
    throw FormatException('\n$message');
  }

  return result!;
}

void _ws(State<Utf16Reader> state) {
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

int? _hexVal(State<Utf16Reader> state) {
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
    state.fail($pos, ParseError.character);
  }
  if (state.ok) {
    final v = $1!;
    $0 = _toHexValue(v);
  }
  return $0;
}

int? _hex(State<Utf16Reader> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos + 1 < source.length &&
      source.codeUnitAt(state.pos) == 35 &&
      source.codeUnitAt(state.pos + 1) == 120;
  if (state.ok) {
    state.pos += 2;
  } else {
    state.fail(state.pos, ParseError.expected, '#x');
  }
  if (state.ok) {
    $0 = _hexVal(state);
    if (!state.ok) {
      state.pos = $pos;
    }
  }
  return $0;
}

int? _rangeChar(State<Utf16Reader> state) {
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
    state.ok = false;
    if (c == 91) {
      state.ok = true;
      state.pos += 1;
    } else if (c == 93) {
      state.ok = true;
      state.pos += 1;
    }
  }
  if (!state.ok) {
    state.fail(state.pos, ParseError.expected, '[');
    state.fail(state.pos, ParseError.expected, ']');
  }
  state.log = $log;
  state.ok = !state.ok;
  if (!state.ok) {
    state.pos = $pos1;
    state.fail(state.pos, ParseError.message, 'Unknown error');
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
        state.fail(state.pos, ParseError.character);
      }
    } else {
      state.fail(state.pos, ParseError.character);
    }
    if (!state.ok) {
      state.pos = $pos;
    }
  }
  return $0;
}

int? _hexOrRangeChar(State<Utf16Reader> state) {
  int? $0;
  $0 = _hex(state);
  if (!state.ok) {
    $0 = _rangeChar(state);
  }
  return $0;
}

Result2<int, int>? _rangeBody(State<Utf16Reader> state) {
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
      state.fail(state.pos, ParseError.expected, '-');
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

int? _charCode(State<Utf16Reader> state) {
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
      state.fail(state.pos, ParseError.character);
    }
  } else {
    state.fail(state.pos, ParseError.character);
  }
  return $0;
}

int? _char(State<Utf16Reader> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 34;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.fail(state.pos, ParseError.expected, '"');
  }
  if (state.ok) {
    $0 = _charCode(state);
    if (state.ok) {
      state.ok =
          state.pos < source.length && source.codeUnitAt(state.pos) == 34;
      if (state.ok) {
        state.pos += 1;
      } else {
        state.fail(state.pos, ParseError.expected, '"');
      }
    }
    if (!state.ok) {
      $0 = null;
      state.pos = $pos;
    }
  }
  return $0;
}

List<Result2<int, int>>? _range(State<Utf16Reader> state) {
  List<Result2<int, int>>? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 91;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.fail(state.pos, ParseError.expected, '[');
  }
  if (state.ok) {
    final $list = <Result2<int, int>>[];
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
        state.fail(state.pos, ParseError.expected, ']');
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

void _verbar(State<Utf16Reader> state) {
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 124;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.fail(state.pos, ParseError.expected, '|');
  }
  if (state.ok) {
    _ws(state);
    if (!state.ok) {
      state.pos = $pos;
    }
  }
}

List<Result2<int, int>>? _ranges(State<Utf16Reader> state) {
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

List<Result2<int, int>>? parse(State<Utf16Reader> state) {
  List<Result2<int, int>>? $0;
  final source = state.source;
  final $pos = state.pos;
  _ws(state);
  if (state.ok) {
    $0 = _ranges(state);
    if (state.ok) {
      state.ok = state.pos >= source.length;
      if (!state.ok) {
        state.fail(state.pos, ParseError.expected, 'EOF');
      }
    }
    if (!state.ok) {
      $0 = null;
      state.pos = $pos;
    }
  }
  return $0;
}

String _errorMessage(Utf16Reader source, List<ParseError> errors) {
  final sb = StringBuffer();
  for (var i = 0; i < errors.length; i++) {
    if (sb.isNotEmpty) {
      sb.writeln();
      sb.writeln();
    }

    final error = errors[i];
    final start = error.start;
    final end = error.end;
    RangeError.checkValidRange(start, end, source.length);
    var row = 1;
    var lineStart = 0, next = 0, pos = 0;
    while (pos < source.length) {
      final c = source.codeUnitAt(pos++);
      if (c == 0xa || c == 0xd) {
        next = c == 0xa ? 0xd : 0xa;
        if (pos < source.length && source.codeUnitAt(pos) == next) {
          pos++;
        }

        if (pos - 1 >= start) {
          break;
        }

        row++;
        lineStart = pos;
      }
    }

    int max(int x, int y) => x > y ? x : y;
    int min(int x, int y) => x < y ? x : y;
    final sourceLen = source.length;
    final lineLimit = min(80, sourceLen);
    final start2 = start;
    final end2 = min(start2 + lineLimit, end);
    final errorLen = end2 - start;
    final extraLen = lineLimit - errorLen;
    final rightLen = min(sourceLen - end2, extraLen - (extraLen >> 1));
    final leftLen = min(start, max(0, lineLimit - errorLen - rightLen));
    var index = start2 - 1;
    final list = <int>[];
    for (var i = 0; i < leftLen && index >= 0; i++) {
      var cc = source.codeUnitAt(index--);
      if ((cc & 0xFC00) == 0xDC00 && (index > 0)) {
        final pc = source.codeUnitAt(index);
        if ((pc & 0xFC00) == 0xD800) {
          cc = 0x10000 + ((pc & 0x3FF) << 10) + (cc & 0x3FF);
          index--;
        }
      }

      list.add(cc);
    }

    final column = start - lineStart + 1;
    final left = String.fromCharCodes(list.reversed);
    final end3 = min(sourceLen, start2 + (lineLimit - leftLen));
    final indicatorLen = max(1, errorLen);
    final right = source.substring(start2, end3);
    var text = left + right;
    text = text.replaceAll('\n', ' ');
    text = text.replaceAll('\r', ' ');
    text = text.replaceAll('\t', ' ');
    sb.writeln('line $row, column $column: $error');
    sb.writeln(text);
    sb.write(' ' * leftLen + '^' * indicatorLen);
  }

  return sb.toString();
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

class State<T> {
  dynamic context;

  int errorPos = -1;

  int lastErrorPos = -1;

  int minErrorPos = -1;

  bool log = true;

  bool ok = false;

  int pos = 0;

  final T source;

  final List<int> _ends = List.filled(150, 0);

  final List<int> _kinds = List.filled(150, 0);

  int _length = 0;

  final List<int> _starts = List.filled(150, 0);

  final List<Object?> _values = List.filled(150, null);

  State(this.source);

  List<ParseError> get errors => _buildErrors();

  @pragma('vm:prefer-inline')
  void fail(int pos, int kind, [Object? value, int start = -1, int end = -1]) {
    ok = false;
    if (log) {
      if (errorPos <= pos && minErrorPos <= pos) {
        if (errorPos < pos) {
          errorPos = pos;
          _length = 0;
        }

        _ends[_length] = end;
        _kinds[_length] = kind;
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
    if (source is Utf16Reader) {
      final reader = source as Utf16Reader;
      if (pos >= reader.length) {
        return '$pos:';
      }

      var length = reader.length - pos;
      length = length > 40 ? 40 : length;
      final string = reader.substring(pos, pos + length);
      return '$pos:$string';
    } else {
      return super.toString();
    }
  }

  List<ParseError> _buildErrors() {
    var start = 0;
    var end = 0;
    void calculate(int index) {
      start = _starts[index];
      if (start < 0) {
        start = errorPos;
        end = start;
      } else {
        end = _ends[index];
        if (end < start) {
          end = start;
        }
      }
    }

    final result = <ParseError>[];
    final expected = <int, List>{};
    for (var i = 0; i < _length; i++) {
      final kind = _kinds[i];
      if (kind == ParseError.expected) {
        calculate(i);
        final value = _values[i];
        var list = expected[start];
        if (list == null) {
          list = [];
          expected[start] = list;
        }

        list.add(value);
      }
    }

    for (final start in expected.keys) {
      final values = expected[start]!.toSet().map(_escape);
      final text = 'Expecting: ${values.join(', ')}';
      final error = ParseError(start, start, text);
      result.add(error);
    }

    for (var i = 0; i < _length; i++) {
      calculate(i);
      final value = _values[i];
      final kind = _kinds[i];
      switch (kind) {
        case ParseError.character:
          if (source is Utf16Reader) {
            final reader = source as Utf16Reader;
            if (start < reader.length) {
              final value = reader.runeAt(errorPos);
              final length = value >= 0xffff ? 2 : 1;
              final escaped = _escape(value);
              final error =
                  ParseError(start, start + length, 'Unexpected $escaped');
              result.add(error);
            } else {
              final error = ParseError(start, start, "Unexpected 'EOF'");
              result.add(error);
            }
          } else {
            final error = ParseError(start, start, 'Unexpected character');
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

class StringReader implements Utf16Reader {
  @override
  final int length;

  final String source;

  StringReader(this.source) : length = source.length;

  @override
  int codeUnitAt(int index) => source.codeUnitAt(index);

  @override
  int indexOf(String text, [int start = 0]) => source.indexOf(text, start);

  @override
  @pragma('vm:prefer-inline')
  int readRune(State<Utf16Reader> state) {
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

  @override
  @pragma('vm:prefer-inline')
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

  @override
  String slice(int start, [int? end]) => source.substring(start, end);

  @override
  bool startsWith(String pattern, [int index = 0]) =>
      source.startsWith(pattern, index);

  @override
  String substring(int start, [int? end]) => source.substring(start, end);
}

abstract class Utf16Reader {
  int get length;

  int codeUnitAt(int index);

  int indexOf(String text, [int start = 0]);

  int readRune(State<Utf16Reader> state);

  int runeAt(int index);

  String slice(int start, [int? end]);

  bool startsWith(String text, int index);

  String substring(int start, [int? end]);
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
