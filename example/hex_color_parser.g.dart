part of 'hex_color_parser.dart';

Color parse(String source) {
  final state = State(source);
  final result = _parse(state);
  if (!state.ok) {
    final message = _errorMessage(source, state.errors);
    throw FormatException('\n$message');
  }

  return result!;
}

int? _hexPrimary(State<String> state) {
  int? $0;
  final source = state.source;
  String? $1;
  final $pos = state.pos;
  var $count = 0;
  while ($count < 2 && state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 70
        ? c <= 57
            ? c >= 48
            : c >= 65
        : c <= 102 && c >= 97;
    if (!ok) {
      break;
    }
    state.pos++;
    $count++;
  }
  state.ok = $count >= 2;
  if (state.ok) {
    $1 = source.substring($pos, state.pos);
  } else {
    state.fail(state.pos, ParseError.character);
    state.pos = $pos;
  }
  if (state.ok) {
    final v = $1!;
    $0 = int.parse(v, radix: 16);
  }
  return $0;
}

Color? _hexColor(State<String> state) {
  Color? $0;
  final source = state.source;
  int? $1;
  final $pos = state.minErrorPos;
  state.minErrorPos = state.pos + 1;
  final $pos1 = state.pos;
  if (state.pos < source.length && source.codeUnitAt(state.pos) == 35) {
    state.ok = true;
    state.pos += 1;
  } else {
    state.fail(state.pos, ParseError.expected, '#');
  }
  if (state.ok) {
    final $pos2 = state.setLastErrorPos(-1);
    final $pos3 = state.pos;
    state.ok = true;
    $1 = state.pos;
    if (state.ok) {
      final $pos4 = state.pos;
      int? $2;
      $2 = _hexPrimary(state);
      if (state.ok) {
        int? $3;
        $3 = _hexPrimary(state);
        if (state.ok) {
          int? $4;
          $4 = _hexPrimary(state);
          if (state.ok) {
            final v1 = $2!;
            final v2 = $3!;
            final v3 = $4!;
            $0 = Color(v1, v2, v3);
          }
        }
      }
      if (!state.ok) {
        state.pos = $pos4;
      }
      if (!state.ok) {
        state.pos = $pos3;
      }
    }
    if (!state.ok) {
      state.fail(
          state.lastErrorPos,
          ParseError.message,
          'A hexadecimal color starting with "#" must be followed by 6 hexadecimal digits',
          $1.as(),
          state.lastErrorPos);
    }
    state.restoreLastErrorPos($pos2);
    if (!state.ok) {
      state.pos = $pos1;
    }
  }
  state.minErrorPos = $pos;
  if (!state.ok) {
    state.fail(state.pos, ParseError.expected, 'hexadecimal color');
  }
  return $0;
}

Color? _parse(State<String> state) {
  Color? $0;
  $0 = _hexColor(state);
  return $0;
}

String _errorMessage(String source, List<ParseError> errors) {
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
    final list = <int>[];
    final iterator = RuneIterator.at(source, start2);
    for (var i = 0; i < leftLen; i++) {
      if (!iterator.movePrevious()) {
        break;
      }

      list.add(iterator.current);
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

extension on Object {
  @pragma('vm:prefer-inline')
  // ignore: unused_element
  R as<R>() => this as R;
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
    final expected = <int, List<Object?>>{};
    for (var i = 0; i < _length; i++) {
      final kind = _kinds[i];
      if (kind == ParseError.expected) {
        calculate(i);
        final value = _values[i];
        (expected[start] ??= []).add(value);
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
          if (source is String) {
            final string = source as String;
            if (start < string.length) {
              final value = string.runeAt(errorPos);
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
