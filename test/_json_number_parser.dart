void main() {
  final s = '100000.00123e3';
  final x = double.parse(s);
  print(s);
  print(x);
  final r = parse(s);
  print(r);
}

num? parse(String source) {
  final state = State(source);
  final r = number(state);
  if (!state.ok) {
    final message = _errorMessage(source, state.errors);
    throw FormatException('\n$message');
  }
  return r!;
}

void _ws(State<String> state) {
  final source = state.source;
  while (state.pos < source.length) {
    final pos = state.pos;
    final c = source.readRune(state);
    final ok = c == 0x9 || c == 0xa || c == 0xd || c == 0x20;
    if (!ok) {
      state.pos = pos;
      break;
    }
  }
  state.ok = true;
}

num? number(State<String> state) {
  num? $0;
  final source = state.source;
  final $pos = state.pos;
  _ws(state);
  if (state.ok) {
    final $pos1 = state.pos;
    state.ok = true;
    final $pos2 = state.pos;
    num? $v;
    while (true) {
      //  '-'?('0'|[1-9][0-9]*)('.'[0-9]+)?([eE][+-]?[0-9]+)?
      const eof = 0x110000;
      const mask = 0x30;
      const powersOfTen = [
        1.0,
        1e1,
        1e2,
        1e3,
        1e4,
        1e5,
        1e6,
        1e7,
        1e8,
        1e9,
        1e10,
        1e11,
        1e12,
        1e13,
        1e14,
        1e15,
        1e16,
        1e17,
        1e18,
        1e19,
        1e20,
        1e21,
        1e22,
      ];
      final length = source.length;
      var pos = state.pos;
      var c = eof;
      if (pos < length) {
        c = source.codeUnitAt(pos);
      } else {
        c = eof;
      }
      var hasSign = false;
      if (c == 0x2d) {
        pos++;
        if (pos < length) {
          c = source.codeUnitAt(pos);
        } else {
          c = eof;
        }
        hasSign = true;
      }
      var digit = c ^ mask;
      if (digit > 9) {
        state.ok = false;
        state.pos = pos;
        break;
      }
      final intPartPos = pos;
      var intPartLen = 0;
      intPartLen = 1;
      var intValue = 0;
      if (digit == 0) {
        pos++;
        if (pos < length) {
          c = source.codeUnitAt(pos);
        } else {
          c = eof;
        }
      } else {
        pos++;
        if (pos < length) {
          c = source.codeUnitAt(pos);
        } else {
          c = eof;
        }
        intValue = digit;
        while (true) {
          digit = c ^ mask;
          if (digit > 9) {
            break;
          }
          pos++;
          if (pos < length) {
            c = source.codeUnitAt(pos);
          } else {
            c = eof;
          }
          if (intPartLen++ < 18) {
            intValue = intValue * 10 + digit;
          }
        }
      }
      var hasDot = false;
      var decPartLen = 0;
      var decValue = 0;
      if (c == 0x2e) {
        pos++;
        if (pos < length) {
          c = source.codeUnitAt(pos);
        } else {
          c = eof;
        }
        hasDot = true;
        digit = c ^ mask;
        if (digit > 9) {
          state.ok = false;
          state.pos = pos;
          break;
        }
        pos++;
        if (pos < length) {
          c = source.codeUnitAt(pos);
        } else {
          c = eof;
        }
        decPartLen = 1;
        decValue = digit;
        while (true) {
          digit = c ^ mask;
          if (digit > 9) {
            break;
          }
          pos++;
          if (pos < length) {
            c = source.codeUnitAt(pos);
          } else {
            c = eof;
          }
          if (decPartLen++ < 18) {
            decValue = decValue * 10 + digit;
          }
        }
      }
      var hasExp = false;
      var hasExpSign = false;
      var expPartLen = 0;
      var exp = 0;
      if (c == 0x45 || c == 0x65) {
        pos++;
        if (pos < length) {
          c = source.codeUnitAt(pos);
        } else {
          c = eof;
        }
        hasExp = true;
        switch (c) {
          case 0x2b:
            pos++;
            if (pos < length) {
              c = source.codeUnitAt(pos);
            } else {
              c = eof;
            }
            break;
          case 0x2d:
            pos++;
            if (pos < length) {
              c = source.codeUnitAt(pos);
            } else {
              c = eof;
            }
            hasExpSign = true;
            break;
        }
        digit = c ^ mask;
        if (digit > 9) {
          state.ok = false;
          state.pos = pos;
          break;
        }
        pos++;
        if (pos < length) {
          c = source.codeUnitAt(pos);
        } else {
          c = eof;
        }
        expPartLen = 1;
        exp = digit;
        while (true) {
          digit = c ^ mask;
          if (digit > 9) {
            break;
          }
          pos++;
          if (pos < length) {
            c = source.codeUnitAt(pos);
          } else {
            c = eof;
          }
          if (expPartLen++ < 18) {
            exp = exp * 10 + digit;
          }
        }
        if (expPartLen > 18) {
          state.pos = pos;
          $v = double.parse(source.substring($pos2, pos));
          break;
        }
        if (hasExpSign) {
          exp = -exp;
        }
      }
      state.pos = pos;
      final singlePart = !hasDot && !hasExp;
      if (singlePart && intPartLen <= 18) {
        $v = hasSign ? -intValue : intValue;
        break;
      }
      if (singlePart && intPartLen == 19) {
        if (intValue == 922337203685477580) {
          final digit = source.codeUnitAt(intPartPos + 18) - 0x30;
          if (digit <= 7) {
            intValue = intValue * 10 + digit;
            $v = hasSign ? -intValue : intValue;
            break;
          }
        }
      }
      var doubleValue = intValue * 1.0;
      var expRest = intPartLen - 18;
      expRest = expRest < 0 ? 0 : expRest;
      exp = expRest + exp;
      final modExp = exp < 0 ? -exp : exp;
      if (modExp > 22) {
        state.pos = pos;
        $v = double.parse(source.substring($pos2, pos));
        break;
      }
      final k = powersOfTen[modExp];
      if (exp > 0) {
        doubleValue *= k;
      } else {
        doubleValue /= k;
      }
      if (decValue != 0) {
        var value = decValue * 1.0;
        final diff = exp - decPartLen;
        final modDiff = diff < 0 ? -diff : diff;
        final sign = diff < 0;
        var rest = modDiff;
        while (rest != 0) {
          var i = rest;
          if (i > 20) {
            i = 20;
          }
          rest -= i;
          final k = powersOfTen[i];
          if (sign) {
            value /= k;
          } else {
            value *= k;
          }
        }
        doubleValue += value;
      }
      $v = hasSign ? -doubleValue : doubleValue;
      break;
    }
    if (state.ok) {
      $0 = $v;
    } else {
      state.fail(state.pos, ParseError.character);
      state.pos = $pos2;
    }
    if (state.ok) {
      _ws(state);
      if (!state.ok) {
        $0 = null;
        state.pos = $pos1;
      }
    }
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

  int start = 0;

  final T source;

  final List<int> _kinds = List.filled(150, 0);

  int _length = 0;

  final List<int> _starts = List.filled(150, 0);

  final List<Object?> _values = List.filled(150, null);

  State(this.source);

  List<ParseError> get errors => _buildErrors();

  @pragma('vm:prefer-inline')
  void fail(int pos, int kind, [Object? value, int start = -1]) {
    if (log) {
      if (errorPos <= pos && minErrorPos <= pos) {
        if (errorPos < pos) {
          errorPos = pos;
          _length = 0;
        }

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

    int max(int x, int y) => x > y ? x : y;
    int min(int x, int y) => x < y ? x : y;
    for (var i = 0; i < _length; i++) {
      final kind = _kinds[i];
      var value = _values[i];
      var start = _starts[i];
      if (start < 0) {
        start = errorPos;
      }

      final end = max(start, errorPos);
      start = min(start, errorPos);
      switch (kind) {
        case ParseError.character:
          if (source is String) {
            final string = source as String;
            if (start < string.length) {
              final value = string.runeAt(errorPos);
              final length = value >= 0xffff ? 2 : 1;
              final escaped = _escape(value);
              final error = ParseError(
                  errorPos, errorPos + length, 'Unexpected $escaped');
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
