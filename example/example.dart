// ignore_for_file: unnecessary_cast

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

void _ws(State<String> state) {
  final source = state.source;
  while (true) {
    final $pos = state.pos;
    int? $c;
    int? $2;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $2 = source.codeUnitAt(state.pos++) as int?;
      $c = $2!;
      state.ok = $c <= 32 && ($c >= 9 && $c <= 10 || $c == 13 || $c == 32);
    }
    if (!state.ok) {
      state.pos = $pos;
      break;
    }
  }
  state.ok = true;
}

dynamic _json(State<String> state) {
  dynamic $0;
  final $pos = state.pos;
  _ws(state);
  dynamic $2;
  $2 = _value(state);
  if (state.ok) {
    state.ok = state.pos >= state.source.length;
    if (!state.ok) {
      state.error = ErrExpected.eof(state.pos);
    } else {
      $0 = $2;
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
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 117;
  if (state.ok) {
    state.pos += 1;
    String? $2;
    final $pos1 = state.pos;
    final $pos2 = state.pos;
    var $count = 0;
    while ($count < 4) {
      final $pos3 = state.pos;
      int? $c;
      int? $5;
      state.ok = state.pos < source.length;
      if (state.ok) {
        $5 = source.codeUnitAt(state.pos++) as int?;
        $c = $5!;
        state.ok = $c <= 102 &&
            ($c >= 48 && $c <= 57 ||
                $c >= 65 && $c <= 70 ||
                $c >= 97 && $c <= 102);
      }
      if (!state.ok) {
        state.pos = $pos3;
        state.error = ErrUnexpected.charOrEof(state.pos, source);
        break;
      } else {
        $count++;
      }
    }
    state.ok = $count >= 4;
    if (state.ok) {
      $2 = state.source.slice($pos1, state.pos) as String?;
      final $v = ($2 as String?)!;
      $0 = _toHexValue($v) as int?;
    } else {
      state.pos = $pos2;
      state.pos = $pos;
    }
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('u'));
  }
  return $0;
}

int? _escaped(State<String> state) {
  final source = state.source;
  int? $0;
  int? $c;
  state.ok = state.pos < source.length;
  state.ok = false;
  if (state.pos < source.length) {
    $c = source.codeUnitAt(state.pos);
    int? $v;
    switch ($c) {
      case 34:
      case 47:
      case 92:
        $v = $c;
        break;
      case 98:
        $v = 8;
        break;
      case 102:
        $v = 12;
        break;
      case 110:
        $v = 10;
        break;
      case 114:
        $v = 13;
        break;
      case 116:
        $v = 9;
        break;
    }
    if ($v != null) {
      state.pos++;
      state.ok = true;
      $0 = $v as int?;
    }
  }
  if (!state.ok) {
    state.error = $c == null
        ? ErrUnexpected.eof(state.pos)
        : ErrUnexpected.charAt(state.pos, source);
    final $error = state.error;
    $0 = _escapeHex(state);
    if (!state.ok) {
      state.error = ErrCombined(state.pos, [$error, state.error]);
    }
  }
  return $0;
}

@pragma('vm:prefer-inline')
void _quote(State<String> state) {
  final source = state.source;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 34;
  if (state.ok) {
    state.pos += 1;
    _ws(state);
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('"'));
  }
}

String? _string(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  final $pos1 = state.pos;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 34;
  if (state.ok) {
    state.pos += 1;
    String? $2;
    state.ok = true;
    final $pos2 = state.pos;
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
      int? $3;
      $3 = _escaped(state);
      if (!state.ok) {
        state.pos = $pos2;
        break;
      }
      if ($list.isEmpty && $str != '') {
        $list.add($str);
      }
      $list.add(($3 as int?)!);
    }
    if (state.ok) {
      if ($list.isEmpty) {
        $2 = $str as String?;
      } else {
        if ($list.length == 1) {
          final c = $list[0] as int;
          $2 = String.fromCharCode(c) as String?;
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
          $2 = buffer.toString() as String?;
        }
      }
      _quote(state);
      if (state.ok) {
        $0 = $2;
      }
    }
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('"'));
  }
  if (!state.ok) {
    state.pos = $pos1;
    state.error =
        ErrNested($pos, 'Malformed string', const Tag('string'), state.error);
  }
  return $0;
}

num? _number(State<String> state) {
  final source = state.source;
  num? $parseNumber() {
    state.ok = true;
    final pos1 = state.pos;
    num? res;
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
          res = double.parse(source.substring(pos1, pos));
          break;
        }
        if (hasExpSign) {
          exp = -exp;
        }
      }
      state.pos = pos;
      final singlePart = !hasDot && !hasExp;
      if (singlePart && intPartLen <= 18) {
        res = hasSign ? -intValue : intValue;
        break;
      }
      if (singlePart && intPartLen == 19) {
        if (intValue == 922337203685477580) {
          final digit = source.codeUnitAt(intPartPos + 18) - 0x30;
          if (digit <= 7) {
            intValue = intValue * 10 + digit;
            res = hasSign ? -intValue : intValue;
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
        res = double.parse(source.substring(pos1, pos));
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
      res = hasSign ? -doubleValue : doubleValue;
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
      state.pos = pos1;
    }
    return res;
  }

  num? $0;
  final $pos = state.pos;
  $0 = $parseNumber() as num?;
  if (!state.ok) {
    state.error =
        ErrNested($pos, 'Malformed number', const Tag('number'), state.error);
  }
  return $0;
}

@pragma('vm:prefer-inline')
void _openBracket(State<String> state) {
  final source = state.source;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 91;
  if (state.ok) {
    state.pos += 1;
    _ws(state);
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('['));
  }
}

List<dynamic>? _values(State<String> state) {
  final source = state.source;
  List<dynamic>? $0;
  var $pos = state.pos;
  final $list = <dynamic>[];
  while (true) {
    dynamic $1;
    $1 = _value(state);
    if (state.ok) {
      $list.add($1);
    } else {
      state.pos = $pos;
      break;
    }
    $pos = state.pos;
    state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 44;
    if (state.ok) {
      state.pos += 1;
      _ws(state);
    } else {
      break;
    }
  }
  state.ok = true;
  $0 = $list as List<dynamic>?;
  return $0;
}

@pragma('vm:prefer-inline')
void _closeBracket(State<String> state) {
  final source = state.source;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 93;
  if (state.ok) {
    state.pos += 1;
    _ws(state);
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag(']'));
  }
}

List<dynamic>? _array(State<String> state) {
  List<dynamic>? $0;
  final $pos = state.pos;
  _openBracket(state);
  if (state.ok) {
    List<dynamic>? $2;
    $2 = _values(state);
    _closeBracket(state);
    if (state.ok) {
      $0 = $2;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

@pragma('vm:prefer-inline')
void _openBrace(State<String> state) {
  final source = state.source;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 123;
  if (state.ok) {
    state.pos += 1;
    _ws(state);
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('{'));
  }
}

MapEntry<String, dynamic>? _keyValue(State<String> state) {
  final source = state.source;
  MapEntry<String, dynamic>? $0;
  final $pos = state.pos;
  String? $1;
  $1 = _string(state);
  if (state.ok) {
    state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 58;
    if (state.ok) {
      state.pos += 1;
      _ws(state);
      dynamic $5;
      $5 = _value(state);
      if (state.ok) {
        final $v = ($1 as String?)!;
        final $v1 = $5;
        $0 = MapEntry($v, $v1) as MapEntry<String, dynamic>?;
      }
    } else {
      state.error = ErrExpected.tag(state.pos, const Tag(':'));
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

List<MapEntry<String, dynamic>>? _keyValues(State<String> state) {
  final source = state.source;
  List<MapEntry<String, dynamic>>? $0;
  var $pos = state.pos;
  final $list = <MapEntry<String, dynamic>>[];
  while (true) {
    MapEntry<String, dynamic>? $1;
    $1 = _keyValue(state);
    if (state.ok) {
      $list.add($1!);
    } else {
      state.pos = $pos;
      break;
    }
    $pos = state.pos;
    state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 44;
    if (state.ok) {
      state.pos += 1;
      _ws(state);
    } else {
      break;
    }
  }
  state.ok = true;
  $0 = $list as List<MapEntry<String, dynamic>>?;
  return $0;
}

@pragma('vm:prefer-inline')
void _closeBrace(State<String> state) {
  final source = state.source;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 125;
  if (state.ok) {
    state.pos += 1;
    _ws(state);
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('}'));
  }
}

dynamic _object(State<String> state) {
  dynamic $0;
  final $pos = state.pos;
  _openBrace(state);
  if (state.ok) {
    List<MapEntry<String, dynamic>>? $2;
    $2 = _keyValues(state);
    _closeBrace(state);
    if (state.ok) {
      final $v = ($2 as List<MapEntry<String, dynamic>>?)!;
      $0 = Map.fromEntries($v) as dynamic;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

bool? _false(State<String> state) {
  final source = state.source;
  bool? $0;
  state.ok = state.pos < source.length &&
      source.codeUnitAt(state.pos) == 102 &&
      source.startsWith('false', state.pos);
  if (state.ok) {
    state.pos += 5;
    $0 = false as bool?;
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('false'));
  }
  return $0;
}

bool? _true(State<String> state) {
  final source = state.source;
  bool? $0;
  state.ok = state.pos < source.length &&
      source.codeUnitAt(state.pos) == 116 &&
      source.startsWith('true', state.pos);
  if (state.ok) {
    state.pos += 4;
    $0 = true as bool?;
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('true'));
  }
  return $0;
}

dynamic _null(State<String> state) {
  final source = state.source;
  dynamic $0;
  state.ok = state.pos < source.length &&
      source.codeUnitAt(state.pos) == 110 &&
      source.startsWith('null', state.pos);
  if (state.ok) {
    state.pos += 4;
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('null'));
  }
  return $0;
}

dynamic _value(State<String> state) {
  dynamic $0;
  dynamic $1;
  $1 = _string(state);
  if (!state.ok) {
    final $error = state.error;
    $1 = _number(state);
    if (!state.ok) {
      final $error1 = state.error;
      $1 = _array(state);
      if (!state.ok) {
        final $error2 = state.error;
        $1 = _object(state);
        if (!state.ok) {
          final $error3 = state.error;
          $1 = _false(state);
          if (!state.ok) {
            final $error4 = state.error;
            $1 = _true(state);
            if (!state.ok) {
              final $error5 = state.error;
              $1 = _null(state);
              if (!state.ok) {
                state.error = ErrCombined(state.pos, [
                  $error,
                  $error1,
                  $error2,
                  $error3,
                  $error4,
                  $error5,
                  state.error
                ]);
              }
            }
          }
        }
      }
    }
  }
  if (state.ok) {
    _ws(state);
    $0 = $1;
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
  int failure = 0;

  @override
  int get hashCode => length.hashCode ^ offset.hashCode;

  int get length;

  int get offset;

  @override
  bool operator ==(other) {
    return other is Err && other.length == length && other.offset == offset;
  }

  int getFailurePosition() => _max(failure, offset);

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
      final errors = <Err>[];
      _flatten(error.error, errors);
      final furthest = errors.map((e) => e.getFailurePosition()).reduce(_max);
      errors.removeWhere((e) => e.getFailurePosition() < furthest);
      final maxEnd = errors.map((e) => e.offset + e.length).reduce(_max);
      final offset = error.offset;
      final expected = ErrExpected.tag(offset, error.tag);
      expected.failure = furthest;
      result.add(expected);
      if (furthest > offset) {
        final message = ErrMessage(offset, maxEnd - offset, error.message);
        message.failure = furthest;
        result.add(message);
        result.addAll(errors);
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
    final result = errors.toList();
    final furthest = result.isEmpty
        ? -1
        : result.map((e) => e.getFailurePosition()).reduce(_max);
    result.removeWhere((e) => e.getFailurePosition() < furthest);
    final map = <int, List<ErrExpected>>{};
    for (final error in result.whereType<ErrExpected>()) {
      final offset = error.offset;
      var list = map[offset];
      if (list == null) {
        list = [];
        map[offset] = list;
      }

      list.add(error);
    }

    result.removeWhere((e) => e is ErrExpected);
    for (var offset in map.keys) {
      final list = map[offset]!;
      final values = list.map((e) => e.value).join(', ');
      result.add(ErrMessage(offset, 0, 'Expected: $values'));
    }

    return result;
  }

  static List<Err> _preprocess(Err error) {
    final result = <Err>[];
    _flatten(error, result);
    return result.toSet().toList();
  }
}

class ErrCombined extends Err {
  final List<Err> errors;

  @override
  final int offset;

  ErrCombined(this.offset, this.errors);

  @override
  int get hashCode {
    var result = super.hashCode;
    for (final error in errors) {
      result ^= error.hashCode;
    }

    return result;
  }

  @override
  int get length => 1;

  @override
  bool operator ==(other) {
    if (super == other) {
      if (other is ErrCombined) {
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
  int get length => 0;

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

class ErrNested extends Err {
  final Err error;

  final String message;

  @override
  final int offset;

  final Tag tag;

  ErrNested(this.offset, this.message, this.tag, this.error);

  @override
  int get hashCode =>
      super.hashCode ^ error.hashCode ^ message.hashCode ^ tag.hashCode;

  @override
  int get length => 0;

  @override
  bool operator ==(other) {
    return super == other &&
        other is ErrNested &&
        other.error == error &&
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
      : length = offset < source.length ? 1 : 0,
        value = offset < source.length
            ? Char(c ?? source.runeAt(offset))
            : const Tag('EOF');

  ErrUnexpected.eof(this.offset)
      : length = 0,
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
  int get length => 0;

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
