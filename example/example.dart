import 'package:source_span/source_span.dart';

dynamic parse(String source) {
  final state = State(source);
  final result = _json(state);
  if (!state.ok) {
    final errors = ParseError.errorReport(state.errors);
    final message = _errorMessage(source, errors);
    throw FormatException('\n$message');
  }

  return result;
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

@pragma('vm:prefer-inline')
int? _escapeHex(State<String> state) {
  int? $0;
  final source = state.source;
  final $newErrorPos = state.newErrorPos;
  state.newErrorPos = -1;
  int? $1;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 117;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.error = ParseError.expected(state.pos, 'u');
  }
  if (state.ok) {
    String? $2;
    final $pos1 = state.pos;
    var $count = 0;
    while ($count < 4 && state.pos < source.length) {
      final c = source.codeUnitAt(state.pos);
      final ok = c <= 102 &&
          (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102);
      if (!ok) {
        break;
      }
      state.pos++;
      $count++;
    }
    state.ok = $count >= 4;
    if (state.ok) {
      $2 = source.substring($pos1, state.pos);
    } else {
      if (state.pos < source.length) {
        final c = source.runeAt(state.pos);
        state.error = ParseError.unexpected(state.pos, 0, c);
      } else {
        state.error = ParseError.unexpected(state.pos, 0, 'EOF');
      }
      state.pos = $pos1;
    }
    if (state.ok) {
      final v1 = $2!;
      $1 = _toHexValue(v1);
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  if (state.ok) {
    $0 = $1;
  } else {
    final length = state.pos - state.newErrorPos;
    state.error = ParseError.message(state.newErrorPos, length,
        'An escape sequence starting with \'\\u\' must be followed by 4 hexadecimal digits');
  }
  state.newErrorPos =
      $newErrorPos > state.newErrorPos ? $newErrorPos : state.newErrorPos;
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
      final c = source.runeAt(state.pos);
      state.error = ParseError.unexpected(state.pos, 0, c);
    }
  } else {
    state.error = ParseError.unexpected(state.pos, 0, 'EOF');
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
    state.error = ParseError.expected(state.pos, '"');
  }
  if (state.ok) {
    _ws(state);
  }
  if (!state.ok) {
    state.pos = $pos;
  }
}

String? _string(State<String> state) {
  String? $0;
  final source = state.source;
  final $minErrorPos = state.minErrorPos;
  state.minErrorPos = state.pos + 1;
  String? $1;
  final $pos = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 34;
  if (state.ok) {
    state.pos += 1;
  } else {
    state.error = ParseError.expected(state.pos, '"');
  }
  if (state.ok) {
    state.ok = true;
    final $pos1 = state.pos;
    final $list = <String>[];
    var $str = '';
    while (state.pos < source.length) {
      final $start = state.pos;
      var $c = 0;
      while (state.pos < source.length) {
        final pos = state.pos;
        $c = source.readRune(state);
        final ok = $c >= 0x20 && $c != 0x22 && $c != 0x5c;
        if (!ok) {
          state.pos = pos;
          break;
        }
      }
      $str = state.pos == $start ? '' : source.substring($start, state.pos);
      if ($str != '' && $list.isNotEmpty) {
        $list.add($str);
      }
      if ($c != 92) {
        break;
      }
      state.pos += 1;
      int? $2;
      $2 = _escaped(state);
      if (!state.ok) {
        state.pos = $pos1;
        break;
      }
      if ($list.isEmpty && $str != '') {
        $list.add($str);
      }
      $list.add(String.fromCharCode($2!));
    }
    if (state.ok) {
      if ($list.isEmpty) {
        $1 = $str;
      } else {
        $1 = $list.join();
      }
    }
    if (state.ok) {
      _quote(state);
    }
  }
  if (!state.ok) {
    $1 = null;
    state.pos = $pos;
  }
  state.minErrorPos = $minErrorPos;
  if (state.ok) {
    $0 = $1;
  } else {
    state.error = ParseError.expected(state.pos, 'string');
  }
  return $0;
}

num? _number(State<String> state) {
  num? $0;
  final source = state.source;
  final $minErrorPos = state.minErrorPos;
  final $newErrorPos = state.newErrorPos;
  state.minErrorPos = state.pos + 1;
  state.newErrorPos = -1;
  num? $1;
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
    $1 = $v;
  } else {
    if (state.pos < source.length) {
      final c = source.runeAt(state.pos);
      state.error = ParseError.unexpected(state.pos, 0, c);
    } else {
      state.error = ParseError.unexpected(state.pos, 0, 'EOF');
    }
    state.pos = $pos;
  }
  state.minErrorPos = $minErrorPos;
  if (state.ok) {
    $0 = $1;
  } else {
    if (state.newErrorPos > state.pos) {
      final length = state.pos - state.newErrorPos;
      state.error =
          ParseError.message(state.newErrorPos, length, 'Malformed number');
    } else {
      state.error = ParseError.expected(state.pos, 'number');
    }
  }
  state.newErrorPos =
      $newErrorPos > state.newErrorPos ? $newErrorPos : state.newErrorPos;
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
    state.error = ParseError.expected(state.pos, '[');
  }
  if (state.ok) {
    _ws(state);
  }
  if (!state.ok) {
    state.pos = $pos;
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
      state.error = ParseError.expected(state.pos, ',');
    }
    if (state.ok) {
      _ws(state);
    }
    if (!state.ok) {
      state.pos = $pos1;
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
    state.error = ParseError.expected(state.pos, ']');
  }
  if (state.ok) {
    _ws(state);
  }
  if (!state.ok) {
    state.pos = $pos;
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
  }
  if (!state.ok) {
    $0 = null;
    state.pos = $pos;
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
    state.error = ParseError.expected(state.pos, '{');
  }
  if (state.ok) {
    _ws(state);
  }
  if (!state.ok) {
    state.pos = $pos;
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
      state.error = ParseError.expected(state.pos, ':');
    }
    if (state.ok) {
      _ws(state);
    }
    if (!state.ok) {
      state.pos = $pos1;
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
      state.error = ParseError.expected(state.pos, ',');
    }
    if (state.ok) {
      _ws(state);
    }
    if (!state.ok) {
      state.pos = $pos1;
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
    state.error = ParseError.expected(state.pos, '}');
  }
  if (state.ok) {
    _ws(state);
  }
  if (!state.ok) {
    state.pos = $pos;
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

bool? _false(State<String> state) {
  bool? $0;
  final source = state.source;
  state.ok = state.pos < source.length &&
      source.codeUnitAt(state.pos) == 102 &&
      source.startsWith('false', state.pos);
  if (state.ok) {
    state.pos += 5;
  } else {
    state.error = ParseError.expected(state.pos, 'false');
  }
  if (state.ok) {
    $0 = false;
  }
  return $0;
}

bool? _true(State<String> state) {
  bool? $0;
  final source = state.source;
  state.ok = state.pos < source.length &&
      source.codeUnitAt(state.pos) == 116 &&
      source.startsWith('true', state.pos);
  if (state.ok) {
    state.pos += 4;
  } else {
    state.error = ParseError.expected(state.pos, 'true');
  }
  if (state.ok) {
    $0 = true;
  }
  return $0;
}

dynamic _null(State<String> state) {
  dynamic $0;
  final source = state.source;
  state.ok = state.pos < source.length &&
      source.codeUnitAt(state.pos) == 110 &&
      source.startsWith('null', state.pos);
  if (state.ok) {
    state.pos += 4;
  } else {
    state.error = ParseError.expected(state.pos, 'null');
  }
  if (state.ok) {
    $0 = null;
  }
  return $0;
}

dynamic _value(State<String> state) {
  dynamic $0;
  final $pos = state.pos;
  $0 = _string(state);
  if (!state.ok) {
    $0 = _number(state);
    if (!state.ok) {
      $0 = _array(state);
      if (!state.ok) {
        $0 = _object(state);
        if (!state.ok) {
          $0 = _false(state);
          if (!state.ok) {
            $0 = _true(state);
            if (!state.ok) {
              $0 = _null(state);
            }
          }
        }
      }
    }
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

    errors.removeWhere((e) => e.kind == ParseErrorKind.expected);
    for (var offset in grouped.keys) {
      final list = grouped[offset]!;
      final values = list.map((e) => '\'${_escape(e.value)}\'').join(', ');
      errors.add(ParseError.message(offset, 0, 'Expected: $values'));
    }

    for (var i = 0; i < errors.length; i++) {
      final error = errors[i];
      if (error.kind == ParseErrorKind.unexpected) {
        errors[i] = ParseError.unexpected(
            error.offset, error.length, '\'${_escape(error.value)}\'');
      }
    }

    return errors;
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

  int minErrorPos = -1;

  int newErrorPos = -1;

  bool ok = false;

  int pos = 0;

  final T source;

  ParseError? _error;

  final List _errors = List.filled(100, null);

  int _errorPos = -1;

  int _length = 0;

  State(this.source);

  set error(ParseError error) {
    final offset = error.offset;
    if (offset >= minErrorPos) {
      if (_errorPos < offset) {
        _errorPos = offset;
        _length = 1;
        _error = error;
        newErrorPos = offset;
      } else if (_errorPos == offset) {
        newErrorPos = offset;
        if (_length < _errors.length) {
          _errors[_length++] = error;
        }
      }
    }
  }

  List<ParseError> get errors {
    if (_length == 0) {
      return [];
    } else if (_length == 1) {
      return [_error!];
    } else {
      return [
        _error!,
        ...List.generate(_length - 1, (i) => _errors[i + 1] as ParseError)
      ];
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
