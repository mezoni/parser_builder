dynamic parse(String source) {
  final state = State(source);
  final result = _json(state);
  if (!state.ok) {
    final message = _errorMessage(source, state.errors);
    throw FormatException('\n$message');
  }

  return result;
}

void _ws(State<String> state) {
  final source = state.source;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 13
        ? c <= 10
            ? c >= 9
            : c == 13
        : c == 32;
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = true;
}

dynamic _json(State<String> state) {
  dynamic $0;
  final source = state.source;
  final $pos = state.pos;
  _ws(state);
  if (state.ok) {
    $0 = _value(state);
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

@pragma('vm:prefer-inline')
int? _escapeHex(State<String> state) {
  int? $0;
  final source = state.source;
  int? $start;
  final $pos = state.pos;
  $start = state.pos;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final c = source.codeUnitAt(state.pos);
    state.ok = c == 117;
    if (state.ok) {
      state.pos++;
    } else {
      state.fail(state.pos, ParseError.character);
    }
  } else {
    state.fail(state.pos, ParseError.character);
  }
  if (state.ok) {
    String? $1;
    final $pos2 = state.setLastErrorPos(-1);
    final $pos3 = state.pos;
    var $count = 0;
    while ($count < 4 && state.pos < source.length) {
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
    state.ok = $count >= 4;
    if (state.ok) {
      $1 = source.substring($pos3, state.pos);
    } else {
      state.fail(state.pos, ParseError.character);
      state.pos = $pos3;
    }
    if (!state.ok) {
      state.fail(
          state.lastErrorPos,
          ParseError.message,
          'An escape sequence starting with \'\\u\' must be followed by 4 hexadecimal digits',
          State.as<int>($start),
          state.lastErrorPos);
    }
    state.restoreLastErrorPos($pos2);
    if (state.ok) {
      final v1 = $1!;
      $0 = _toHexValue(v1);
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

int? _escaped(State<String> state) {
  int? $0;
  final source = state.source;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final c = source.codeUnitAt(state.pos);
    int? v;
    switch (c) {
      case 34:
      case 47:
      case 92:
        v = c;
        break;
      case 98:
        v = 8;
        break;
      case 102:
        v = 12;
        break;
      case 110:
        v = 10;
        break;
      case 114:
        v = 13;
        break;
      case 116:
        v = 9;
        break;
    }
    state.ok = v != null;
    if (state.ok) {
      state.pos++;
      $0 = v;
    } else {
      state.fail(state.pos, ParseError.character);
    }
  } else {
    state.fail(state.pos, ParseError.character);
  }
  if (!state.ok) {
    $0 = _escapeHex(state);
  }
  return $0;
}

@pragma('vm:prefer-inline')
void _quote(State<String> state) {
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 34;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.fail(state.pos, ParseError.expected, '"');
  }
  if (state.ok) {
    _ws(state);
    if (!state.ok) {
      state.pos = $pos;
    }
  }
}

String? _string(State<String> state) {
  String? $0;
  final source = state.source;
  int? $start;
  final $pos = state.minErrorPos;
  state.minErrorPos = state.pos + 1;
  final $pos1 = state.setLastErrorPos(-1);
  final $pos2 = state.pos;
  $start = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 34;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.fail(state.pos, ParseError.expected, '"');
  }
  if (state.ok) {
    state.ok = true;
    final $pos3 = state.pos;
    final $list = <String>[];
    var $str = '';
    while (state.pos < source.length) {
      final $start1 = state.pos;
      var $c = 0;
      while (state.pos < source.length) {
        final pos = state.pos;
        $c = source.readRune(state);
        final ok = $c <= 91
            ? $c <= 33
                ? $c >= 32
                : $c >= 35
            : $c <= 1114111 && $c >= 93;
        if (!ok) {
          state.pos = pos;
          break;
        }
      }
      $str = state.pos == $start1 ? '' : source.substring($start1, state.pos);
      if ($str != '' && $list.isNotEmpty) {
        $list.add($str);
      }
      if ($c != 92) {
        break;
      }
      state.pos += 1;
      int? $1;
      $1 = _escaped(state);
      if (!state.ok) {
        state.pos = $pos3;
        break;
      }
      if ($list.isEmpty && $str != '') {
        $list.add($str);
      }
      $list.add(String.fromCharCode($1!));
    }
    if (state.ok) {
      if ($list.isEmpty) {
        $0 = $str;
      } else {
        $0 = $list.join();
      }
    }
    if (state.ok) {
      _quote(state);
      if (!state.ok) {
        state.fail(state.lastErrorPos, ParseError.message,
            'Unterminated string', State.as<int>($start));
      }
    }
    if (!state.ok) {
      $0 = null;
      state.pos = $pos2;
    }
  }
  state.restoreLastErrorPos($pos1);
  state.minErrorPos = $pos;
  if (!state.ok) {
    state.fail(state.pos, ParseError.expected, 'string');
  }
  return $0;
}

@pragma('vm:prefer-inline')
void _openBracket(State<String> state) {
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 91;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.fail(state.pos, ParseError.expected, '[');
  }
  if (state.ok) {
    _ws(state);
    if (!state.ok) {
      state.pos = $pos;
    }
  }
}

List<dynamic>? _values(State<String> state) {
  List<dynamic>? $0;
  final source = state.source;
  var $pos = state.pos;
  final $list = <dynamic>[];
  while (true) {
    dynamic $1;
    $1 = _value(state);
    if (!state.ok) {
      state.pos = $pos;
      break;
    }
    $list.add($1);
    $pos = state.pos;
    final $pos1 = state.pos;
    state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 44;
    if (state.ok) {
      state.pos += 1;
    } else {
      state.fail(state.pos, ParseError.expected, ',');
    }
    if (state.ok) {
      _ws(state);
      if (!state.ok) {
        state.pos = $pos1;
      }
    }
    if (!state.ok) {
      break;
    }
  }
  state.ok = true;
  if (state.ok) {
    $0 = $list;
  }
  return $0;
}

@pragma('vm:prefer-inline')
void _closeBracket(State<String> state) {
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 93;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.fail(state.pos, ParseError.expected, ']');
  }
  if (state.ok) {
    _ws(state);
    if (!state.ok) {
      state.pos = $pos;
    }
  }
}

List<dynamic>? _array(State<String> state) {
  List<dynamic>? $0;
  final $pos = state.pos;
  _openBracket(state);
  if (state.ok) {
    $0 = _values(state);
    if (state.ok) {
      _closeBracket(state);
    }
    if (!state.ok) {
      $0 = null;
      state.pos = $pos;
    }
  }
  return $0;
}

@pragma('vm:prefer-inline')
void _openBrace(State<String> state) {
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 123;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.fail(state.pos, ParseError.expected, '{');
  }
  if (state.ok) {
    _ws(state);
    if (!state.ok) {
      state.pos = $pos;
    }
  }
}

MapEntry<String, dynamic>? _keyValue(State<String> state) {
  MapEntry<String, dynamic>? $0;
  final source = state.source;
  final $pos = state.pos;
  String? $1;
  $1 = _string(state);
  if (state.ok) {
    final $pos1 = state.pos;
    state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 58;
    if (state.ok) {
      state.pos += 1;
    } else {
      state.fail(state.pos, ParseError.expected, ':');
    }
    if (state.ok) {
      _ws(state);
      if (!state.ok) {
        state.pos = $pos1;
      }
    }
    if (state.ok) {
      dynamic $2;
      $2 = _value(state);
      if (state.ok) {
        final v1 = $1!;
        final v2 = $2;
        $0 = MapEntry(v1, v2);
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

List<MapEntry<String, dynamic>>? _keyValues(State<String> state) {
  List<MapEntry<String, dynamic>>? $0;
  final source = state.source;
  var $pos = state.pos;
  final $list = <MapEntry<String, dynamic>>[];
  while (true) {
    MapEntry<String, dynamic>? $1;
    $1 = _keyValue(state);
    if (!state.ok) {
      state.pos = $pos;
      break;
    }
    $list.add($1!);
    $pos = state.pos;
    final $pos1 = state.pos;
    state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 44;
    if (state.ok) {
      state.pos += 1;
    } else {
      state.fail(state.pos, ParseError.expected, ',');
    }
    if (state.ok) {
      _ws(state);
      if (!state.ok) {
        state.pos = $pos1;
      }
    }
    if (!state.ok) {
      break;
    }
  }
  state.ok = true;
  if (state.ok) {
    $0 = $list;
  }
  return $0;
}

@pragma('vm:prefer-inline')
void _closeBrace(State<String> state) {
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 125;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.fail(state.pos, ParseError.expected, '}');
  }
  if (state.ok) {
    _ws(state);
    if (!state.ok) {
      state.pos = $pos;
    }
  }
}

dynamic _object(State<String> state) {
  dynamic $0;
  final $pos = state.pos;
  _openBrace(state);
  if (state.ok) {
    List<MapEntry<String, dynamic>>? $1;
    $1 = _keyValues(state);
    if (state.ok) {
      _closeBrace(state);
      if (state.ok) {
        final v1 = $1!;
        $0 = Map.fromEntries(v1);
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

num? _number(State<String> state) {
  num? $0;
  final source = state.source;
  final $log = state.log;
  state.log = false;
  state.ok = true;
  final $pos = state.pos;
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
        $v = double.parse(source.substring($pos, pos));
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
      $v = double.parse(source.substring($pos, pos));
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
    state.pos = $pos;
  }
  state.log = $log;
  if (!state.ok) {
    state.fail(state.pos, ParseError.expected, 'number');
  }
  return $0;
}

dynamic _value(State<String> state) {
  dynamic $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final pos = state.pos;
    final c = source.codeUnitAt(pos);
    state.ok = false;
    if (c == 34) {
      $0 = _string(state);
    } else if (c == 91) {
      $0 = _array(state);
    } else if (c == 123) {
      $0 = _object(state);
    } else if (c == 102) {
      if (source.startsWith('false', pos)) {
        state.ok = true;
        state.pos += 5;
        if (state.ok) {
          $0 = false;
        }
      }
    } else if (c == 116) {
      if (source.startsWith('true', pos)) {
        state.ok = true;
        state.pos += 4;
        if (state.ok) {
          $0 = true;
        }
      }
    } else if (c == 110) {
      if (source.startsWith('null', pos)) {
        state.ok = true;
        state.pos += 4;
        if (state.ok) {
          $0 = null;
        }
      }
    } else {
      $0 = _number(state);
    }
  }
  if (!state.ok) {
    state.fail(state.pos, ParseError.expected, 'string');
    state.fail(state.pos, ParseError.expected, '[');
    state.fail(state.pos, ParseError.expected, '}');
    state.fail(state.pos, ParseError.expected, 'false');
    state.fail(state.pos, ParseError.expected, 'true');
    state.fail(state.pos, ParseError.expected, 'null');
    state.fail(state.pos, ParseError.expected, 'number');
  }
  if (state.ok) {
    _ws(state);
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
      final values = expected[start]!.toSet().map((e) => _escape(e));
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

  static T as<T>(T? value) => value as T;
}

@pragma('vm:prefer-inline')
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
