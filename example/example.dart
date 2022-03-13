// ignore_for_file: unused_local_variable

import 'package:source_span/source_span.dart';

dynamic parse(String source) {
  final state = State(source);
  final result = _json(state);
  if (!state.ok) {
    final errors = Err.errorReport(state.error);
    final message = _errorMessage(source, errors);
    throw FormatException('\n$message');
  }

  return result;
}

bool? _ws(State<String> state) {
  final source = state.source;
  bool? $0;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 32 && (c >= 9 && c <= 10 || c == 13 || c == 32);
    if (ok) {
      state.pos++;
      continue;
    }
    break;
  }
  state.ok = true;
  if (state.ok) {
    $0 = true;
  }
  return $0;
}

bool? _eof(State<String> state) {
  bool? $0;
  state.ok = state.pos >= state.source.length;
  if (state.ok) {
    $0 = true;
  } else if (state.log) {
    state.error = ErrExpected.eof(state.pos);
  }
  return $0;
}

dynamic _json(State<String> state) {
  dynamic $0;
  final $pos = state.pos;
  bool? $1;
  $1 = _ws(state);
  if (state.ok) {
    dynamic $2;
    $2 = _value(state);
    if (state.ok) {
      bool? $3;
      $3 = _eof(state);
      if (state.ok) {
        $0 = $2;
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

@pragma('vm:prefer-inline')
int? _escapeHex(State<String> state) {
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  String? $1;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 117;
  if (state.ok) {
    state.pos++;
    $1 = 'u';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('u'));
  }
  if (state.ok) {
    String? $2;
    final $pos1 = state.pos;
    var $cnt = 0;
    while ($cnt < 4 && state.pos < source.length) {
      final c = source.codeUnitAt(state.pos);
      final ok = c <= 102 &&
          (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102);
      if (ok) {
        state.pos++;
        $cnt++;
        continue;
      }
      break;
    }
    state.ok = $cnt >= 4;
    if (state.ok) {
      $2 = source.substring($pos1, state.pos);
    } else {
      if (state.log) {
        state.error = ErrUnexpected.charOrEof(state.pos, source);
      }
      state.pos = $pos1;
    }
    if (state.ok) {
      $0 = _toHexValue($2!);
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

int? _escaped(State<String> state) {
  final source = state.source;
  int? $0;
  int? $1;
  state.ok = false;
  if (state.pos < source.length) {
    var c = source.codeUnitAt(state.pos);
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
    if (v != null) {
      state.pos++;
      state.ok = true;
      $1 = v;
    } else if (state.log) {
      state.error = ErrUnexpected.charAt(state.pos, source);
    }
  } else if (state.log) {
    state.error = ErrUnexpected.eof(state.pos);
  }
  if (state.ok) {
    $0 = $1!;
  } else {
    final $error = state.error;
    int? $2;
    $2 = _escapeHex(state);
    if (state.ok) {
      $0 = $2!;
    } else if (state.log) {
      state.error = ErrCombined(state.pos, [$error, state.error]);
    }
  }
  return $0;
}

@pragma('vm:prefer-inline')
String? _quote(State<String> state) {
  final source = state.source;
  String? $0;
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

String? _string(State<String> state) {
  final source = state.source;
  String? $0;
  String? $1;
  final $pos = state.pos;
  String? $2;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 34;
  if (state.ok) {
    state.pos++;
    $2 = '"';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('"'));
  }
  if (state.ok) {
    String? $3;
    state.ok = true;
    final $pos1 = state.pos;
    final $list = [];
    var $str = '';
    while (state.pos < source.length) {
      final $start = state.pos;
      var $c = 0;
      while (state.pos < source.length) {
        final pos = state.pos;
        $c = source.readRune(state);
        final ok = $c >= 0x20 && $c != 0x22 && $c != 0x5c;
        if (ok) {
          continue;
        }
        state.pos = pos;
        break;
      }
      $str = state.pos == $start ? '' : source.substring($start, state.pos);
      if ($str != '' && $list.isNotEmpty) {
        $list.add($str);
      }
      if ($c != 92) {
        break;
      }
      state.pos += 1;
      int? $4;
      $4 = _escaped(state);
      if (!state.ok) {
        state.pos = $pos1;
        break;
      }
      if ($list.isEmpty && $str != '') {
        $list.add($str);
      }
      $list.add($4!);
    }
    if (state.ok) {
      if ($list.isEmpty) {
        $3 = $str;
      } else if ($list.length == 1) {
        final c = $list[0] as int;
        $3 = String.fromCharCode(c);
      } else {
        final buffer = StringBuffer();
        for (var i = 0; i < $list.length; i++) {
          final obj = $list[i];
          if (obj is int) {
            buffer.writeCharCode(obj);
          } else {
            buffer.write(obj);
          }
        }
        $3 = buffer.toString();
      }
    }
    if (state.ok) {
      String? $5;
      $5 = _quote(state);
      if (state.ok) {
        $1 = $3!;
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  if (state.ok) {
    $0 = $1;
  } else if (state.log) {
    state.error = ErrNested(
        state.pos, 'Malformed string', const Tag('string'), [state.error]);
  }
  return $0;
}

@pragma('vm:prefer-inline')
String? _openBrace(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  String? $1;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 123;
  if (state.ok) {
    state.pos++;
    $1 = '{';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('{'));
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

@pragma('vm:prefer-inline')
String? _colon(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  String? $1;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 58;
  if (state.ok) {
    state.pos++;
    $1 = ':';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag(':'));
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

MapEntry<String, dynamic>? _keyValue(State<String> state) {
  MapEntry<String, dynamic>? $0;
  final $pos = state.pos;
  String? $1;
  $1 = _string(state);
  if (state.ok) {
    String? $2;
    $2 = _colon(state);
    if (state.ok) {
      dynamic $3;
      $3 = _value(state);
      if (state.ok) {
        $0 = MapEntry($1!, $3);
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

@pragma('vm:prefer-inline')
String? _comma(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  String? $1;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 44;
  if (state.ok) {
    state.pos++;
    $1 = ',';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag(','));
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

List<MapEntry<String, dynamic>>? _keyValues(State<String> state) {
  List<MapEntry<String, dynamic>>? $0;
  final $log = state.log;
  state.log = false;
  var $pos = state.pos;
  final $list = <MapEntry<String, dynamic>>[];
  for (;;) {
    MapEntry<String, dynamic>? $1;
    $1 = _keyValue(state);
    if (!state.ok) {
      state.pos = $pos;
      break;
    }
    $list.add($1!);
    $pos = state.pos;
    String? $2;
    $2 = _comma(state);
    if (!state.ok) {
      break;
    }
  }
  state.ok = true;
  if (state.ok) {
    $0 = $list;
  }
  state.log = $log;
  return $0;
}

@pragma('vm:prefer-inline')
String? _closeBrace(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  String? $1;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 125;
  if (state.ok) {
    state.pos++;
    $1 = '}';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('}'));
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

dynamic _object(State<String> state) {
  dynamic $0;
  final $pos = state.pos;
  String? $1;
  $1 = _openBrace(state);
  if (state.ok) {
    List<MapEntry<String, dynamic>>? $2;
    $2 = _keyValues(state);
    if (state.ok) {
      String? $3;
      $3 = _closeBrace(state);
      if (state.ok) {
        $0 = Map.fromEntries($2!);
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

@pragma('vm:prefer-inline')
String? _openBracket(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  String? $1;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 91;
  if (state.ok) {
    state.pos++;
    $1 = '[';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('['));
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

List<dynamic>? _values(State<String> state) {
  List<dynamic>? $0;
  final $log = state.log;
  state.log = false;
  var $pos = state.pos;
  final $list = <dynamic>[];
  for (;;) {
    dynamic $1;
    $1 = _value(state);
    if (!state.ok) {
      state.pos = $pos;
      break;
    }
    $list.add($1);
    $pos = state.pos;
    String? $2;
    $2 = _comma(state);
    if (!state.ok) {
      break;
    }
  }
  state.ok = true;
  if (state.ok) {
    $0 = $list;
  }
  state.log = $log;
  return $0;
}

@pragma('vm:prefer-inline')
String? _closeBracket(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  String? $1;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 93;
  if (state.ok) {
    state.pos++;
    $1 = ']';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag(']'));
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

List<dynamic>? _array(State<String> state) {
  List<dynamic>? $0;
  final $pos = state.pos;
  String? $1;
  $1 = _openBracket(state);
  if (state.ok) {
    List<dynamic>? $2;
    $2 = _values(state);
    if (state.ok) {
      String? $3;
      $3 = _closeBracket(state);
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

num? _number(State<String> state) {
  final source = state.source;
  num? $0;
  num? $1;
  state.ok = true;
  final $pos = state.pos;
  for (;;) {
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
        $1 = double.parse(source.substring($pos, pos));
        break;
      }
      if (hasExpSign) {
        exp = -exp;
      }
    }
    state.pos = pos;
    final singlePart = !hasDot && !hasExp;
    if (singlePart && intPartLen <= 18) {
      $1 = hasSign ? -intValue : intValue;
      break;
    }
    if (singlePart && intPartLen == 19) {
      if (intValue == 922337203685477580) {
        final digit = source.codeUnitAt(intPartPos + 18) - 0x30;
        if (digit <= 7) {
          intValue = intValue * 10 + digit;
          $1 = hasSign ? -intValue : intValue;
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
      $1 = double.parse(source.substring($pos, pos));
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
    $1 = hasSign ? -doubleValue : doubleValue;
    break;
  }
  if (!state.ok) {
    if (state.pos < source.length) {
      var c = source.codeUnitAt(state.pos);
      if (c > 0xd7ff) {
        c = source.runeAt(state.pos);
      }
      state.error = ErrUnexpected.char(state.pos, Char(c));
    } else {
      state.error = ErrUnexpected.eof(state.pos);
    }
    state.pos = $pos;
  }
  if (state.ok) {
    $0 = $1;
  } else if (state.log) {
    state.error = ErrNested(
        state.pos, 'Malformed number', const Tag('number'), [state.error]);
  }
  return $0;
}

dynamic _value(State<String> state) {
  final source = state.source;
  dynamic $0;
  final $pos = state.pos;
  dynamic $1;
  final $pos1 = state.pos;
  var $matched = false;
  state.ok = false;
  if ($pos1 < source.length) {
    final c = source.codeUnitAt($pos1);
    switch (c) {
      case 34:
        $matched = true;
        String? $2;
        $2 = _string(state);
        if (state.ok) {
          $1 = $2;
        }
        break;
      case 123:
        $matched = true;
        dynamic $3;
        $3 = _object(state);
        if (state.ok) {
          $1 = $3;
        }
        break;
      case 91:
        $matched = true;
        List<dynamic>? $4;
        $4 = _array(state);
        if (state.ok) {
          $1 = $4;
        }
        break;
      case 102:
        if (source.startsWith('false', $pos1)) {
          $matched = true;
          dynamic $5;
          state.ok = state.pos + 5 <= source.length;
          if (state.ok) {
            state.pos += 5;
            $5 = false;
          } else if (state.log) {
            state.error = ErrUnexpected.eof(state.pos);
          }
          if (state.ok) {
            $1 = $5;
          }
          break;
        }
        break;
      case 116:
        if (source.startsWith('true', $pos1)) {
          $matched = true;
          dynamic $6;
          state.ok = state.pos + 4 <= source.length;
          if (state.ok) {
            state.pos += 4;
            $6 = true;
          } else if (state.log) {
            state.error = ErrUnexpected.eof(state.pos);
          }
          if (state.ok) {
            $1 = $6;
          }
          break;
        }
        break;
      case 110:
        if (source.startsWith('null', $pos1)) {
          $matched = true;
          dynamic $7;
          state.ok = state.pos + 4 <= source.length;
          if (state.ok) {
            state.pos += 4;
            $7 = null;
          } else if (state.log) {
            state.error = ErrUnexpected.eof(state.pos);
          }
          if (state.ok) {
            $1 = $7;
          }
          break;
        }
        break;
      default:
        $matched = true;
        num? $8;
        $8 = _number(state);
        if (state.ok) {
          $1 = $8;
        }
    }
  }
  if (!state.ok && state.log) {
    List<Err> errors = [
      ErrExpected.tag(state.pos, const Tag('[')),
      ErrExpected.tag(state.pos, const Tag('{')),
      ErrExpected.tag(state.pos, const Tag('false')),
      ErrExpected.tag(state.pos, const Tag('null')),
      ErrExpected.tag(state.pos, const Tag('number')),
      ErrExpected.tag(state.pos, const Tag('string')),
      ErrExpected.tag(state.pos, const Tag('true'))
    ];
    if ($matched) {
      errors.add(state.error);
    }
    state.error = ErrCombined(state.pos, errors);
  }
  if (state.ok) {
    bool? $9;
    $9 = _ws(state);
    if (state.ok) {
      $0 = $1;
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
      final inner = <Err>[];
      for (final error in error.errors) {
        _flatten(error, inner);
      }

      final furthest = inner.map((e) => e.offset).reduce(_max);
      inner.removeWhere((e) => e.offset < furthest);
      final offset = error.offset;
      result.add(ErrExpected.tag(offset, error.tag));
      if (furthest > offset) {
        result.add(ErrMessage(offset, furthest - offset, error.message));
        result.addAll(inner.map((e) => _ErrBoxed(offset, e)));
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
    var result = errors.toList();
    final furthest =
        result.isEmpty ? -1 : result.map((e) => e.offset).reduce(_max);
    result.removeWhere((e) => e.offset < furthest);
    final expected =
        result.whereType<ErrExpected>().map((e) => '${e.value}').toList();
    if (expected.isNotEmpty) {
      expected.sort();
      result.removeWhere((e) => e is ErrExpected);
      result.add(ErrMessage(furthest, 1, 'Expected: ${expected.join(', ')}'));
    }

    for (var i = 0; i < result.length; i++) {
      final error = result[i];
      if (error is _ErrBoxed) {
        result[i] = error.error;
      }
    }

    return result;
  }

  static List<Err> _preprocess(Err error) {
    final result = <Err>[];
    _flatten(error, result);
    return result.toSet().toList();
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

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return super == other && other is ErrCombined;
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
  int get length => 1;

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

class ErrNested extends ErrWithErrors {
  @override
  final List<Err> errors;

  final String message;

  @override
  final int offset;

  final Tag tag;

  ErrNested(this.offset, this.message, this.tag, this.errors);

  @override
  int get length => 1;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return super == other &&
        other is ErrNested &&
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
  int get length => 1;

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

abstract class ErrWithErrors extends Err {
  List<Err> get errors;

  @override
  int get hashCode {
    var result = super.hashCode;
    for (final error in errors) {
      result ^= error.hashCode;
    }

    return result;
  }

  @override
  bool operator ==(other) {
    if (super == other) {
      if (other is ErrWithErrors) {
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

class _ErrBoxed extends Err {
  final Err error;

  @override
  int offset;

  _ErrBoxed(this.offset, this.error);

  @override
  int get length => 1;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return super == other && other is _ErrBoxed && other.error == error;
  }

  @override
  String toString() {
    return 'Boxed: $error';
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
