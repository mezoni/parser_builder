import 'package:tuple/tuple.dart';

int _toBinary(int left, String operator, int right) {
  switch (operator) {
    case '+':
      return left + right;
    case '-':
      return left - right;
    case '*':
      return left * right;
    case '/':
      return left ~/ right;
    default:
      throw StateError('Unknown operator: $operator');
  }
}

int _toPostfix(int expression, String operator) {
  switch (operator) {
    case '--':
      return --expression;
    case '++':
      return ++expression;
    default:
      throw StateError('Unknown operator: $operator');
  }
}

int _toPrefix(String operator, int expression) {
  switch (operator) {
    case '-':
      return -expression;
    case '--':
      return --expression;
    case '++':
      return ++expression;
    default:
      throw StateError('Unknown operator: $operator');
  }
}

String? alpha0(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 122 && (c >= 65 && c <= 90 || c >= 97 && c <= 122);
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = true;
  if (state.ok) {
    $0 = $pos == state.pos ? '' : source.substring($pos, state.pos);
  }
  return $0;
}

String? alpha1(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 122 && (c >= 65 && c <= 90 || c >= 97 && c <= 122);
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = state.pos != $pos;
  if (state.ok) {
    $0 = source.substring($pos, state.pos);
  } else if (state.log) {
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  return $0;
}

String? alphanumeric0(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 122 &&
        (c >= 48 && c <= 57 || c >= 65 && c <= 90 || c >= 97 && c <= 122);
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = true;
  if (state.ok) {
    $0 = $pos == state.pos ? '' : source.substring($pos, state.pos);
  }
  return $0;
}

String? alphanumeric1(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 122 &&
        (c >= 48 && c <= 57 || c >= 65 && c <= 90 || c >= 97 && c <= 122);
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = state.pos != $pos;
  if (state.ok) {
    $0 = source.substring($pos, state.pos);
  } else if (state.log) {
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  return $0;
}

int? char16(State<String> state) {
  int? $0;
  final source = state.source;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 80;
  if (state.ok) {
    state.pos++;
    $0 = 80;
  } else if (state.log) {
    state.error = ErrExpected.char(state.pos, const Char(80));
  }
  return $0;
}

int? altC16OrC32(State<String> state) {
  int? $0;
  final source = state.source;
  $0 = char16(state);
  if (!state.ok) {
    final $1 = state.error;
    state.ok = state.pos < source.length && source.runeAt(state.pos) == 119296;
    if (state.ok) {
      state.pos += 2;
      $0 = 119296;
    } else if (state.log) {
      state.error = ErrExpected.char(state.pos, const Char(119296));
    }
    if (!state.ok) {
      final $2 = state.error;
      if (state.log) {
        state.error = ErrCombined(state.pos, [$1, $2]);
      }
    }
  }
  return $0;
}

int? char32(State<String> state) {
  int? $0;
  final source = state.source;
  state.ok = state.pos < source.length && source.runeAt(state.pos) == 119296;
  if (state.ok) {
    state.pos += 2;
    $0 = 119296;
  } else if (state.log) {
    state.error = ErrExpected.char(state.pos, const Char(119296));
  }
  return $0;
}

void andC32OrC16(State<String> state) {
  final $pos = state.pos;
  final $log = state.log;
  state.log = false;
  char32(state);
  if (!state.ok) {
    final $1 = state.error;
    char16(state);
    if (!state.ok) {
      final $2 = state.error;
      if (state.log) {
        state.error = ErrCombined(state.pos, [$1, $2]);
      }
    }
  }
  state.log = $log;
  if (state.ok) {
    state.pos = $pos;
    if ($log) {
      state.error = ErrUnknown(state.pos);
    }
  }
}

int? anyChar(State<String> state) {
  int? $0;
  final source = state.source;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $0 = source.readRune(state);
  } else if (state.log) {
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
}

int? _primaryExpression(State<String> state) {
  int? $0;
  final source = state.source;
  String? $1;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c >= 48 && c <= 57;
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = state.pos != $pos;
  if (state.ok) {
    $1 = source.substring($pos, state.pos);
  } else if (state.log) {
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  if (state.ok) {
    final v = $1!;
    $0 = int.parse(v);
  }
  return $0;
}

int? _binaryExpressionMul(State<String> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  int? $left;
  var $ok = false;
  int? $1;
  $1 = _primaryExpression(state);
  if (state.ok) {
    $ok = true;
    $left = $1;
    while (true) {
      String? $2;
      state.ok = state.pos < source.length;
      if (state.ok) {
        final pos = state.pos;
        final c = source.codeUnitAt(pos);
        String? v;
        switch (c) {
          case 42:
            state.pos++;
            v = '*';
            break;
          case 126:
            if (source.startsWith('~/', pos)) {
              state.pos += 2;
              v = '~/';
              break;
            }
            break;
        }
        state.ok = v != null;
        if (state.ok) {
          $2 = v;
        }
      }
      if (!state.ok && state.log) {
        state.error = ErrCombined(state.pos, [
          ErrExpected.tag(state.pos, const Tag('*')),
          ErrExpected.tag(state.pos, const Tag('~/'))
        ]);
      }
      if (!state.ok) {
        break;
      }
      int? $3;
      $3 = _primaryExpression(state);
      if (!state.ok) {
        $ok = false;
        state.pos = $pos;
        break;
      }
      final $op = $2!;
      final $right = $3!;
      $left = _toBinary($left!, $op, $right);
    }
  }
  state.ok = $ok;
  if (state.ok) {
    $0 = $left;
  }
  return $0;
}

int? binaryExpressionAdd(State<String> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  int? $left;
  var $ok = false;
  int? $1;
  $1 = _binaryExpressionMul(state);
  if (state.ok) {
    $ok = true;
    $left = $1;
    while (true) {
      String? $2;
      state.ok = state.pos < source.length;
      if (state.ok) {
        final pos = state.pos;
        final c = source.codeUnitAt(pos);
        String? v;
        switch (c) {
          case 43:
            state.pos++;
            v = '+';
            break;
          case 45:
            state.pos++;
            v = '-';
            break;
        }
        state.ok = v != null;
        if (state.ok) {
          $2 = v;
        }
      }
      if (!state.ok && state.log) {
        state.error = ErrCombined(state.pos, [
          ErrExpected.tag(state.pos, const Tag('+')),
          ErrExpected.tag(state.pos, const Tag('-'))
        ]);
      }
      if (!state.ok) {
        break;
      }
      int? $3;
      $3 = _binaryExpressionMul(state);
      if (!state.ok) {
        $ok = false;
        state.pos = $pos;
        break;
      }
      final $op = $2!;
      final $right = $3!;
      $left = _toBinary($left!, $op, $right);
    }
  }
  state.ok = $ok;
  if (state.ok) {
    $0 = $left;
  }
  return $0;
}

String? tagAbc(State<String> state) {
  String? $0;
  final source = state.source;
  state.ok = state.pos < source.length &&
      source.codeUnitAt(state.pos) == 97 &&
      source.startsWith('abc', state.pos);
  if (state.ok) {
    state.pos += 3;
    $0 = 'abc';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('abc'));
  }
  return $0;
}

Tuple2<String, List<String>>? consumedSeparatedAbcC32(State<String> state) {
  Tuple2<String, List<String>>? $0;
  final source = state.source;
  final $pos = state.pos;
  List<String>? $1;
  var $pos1 = state.pos;
  final $list = <String>[];
  final $log = state.log;
  while (true) {
    String? $2;
    $2 = tagAbc(state);
    if (!state.ok) {
      state.pos = $pos1;
      break;
    }
    state.log = false;
    $list.add($2!);
    $pos1 = state.pos;
    char32(state);
    if (!state.ok) {
      break;
    }
  }
  state.log = $log;
  state.ok = $list.isNotEmpty;
  if (state.ok) {
    $1 = $list;
  }
  if (state.ok) {
    final v = source.slice($pos, state.pos);
    $0 = Tuple2(v, $1!);
  }
  return $0;
}

int? delimited(State<String> state) {
  int? $0;
  final $pos = state.pos;
  char16(state);
  if (state.ok) {
    $0 = char32(state);
    if (state.ok) {
      char16(state);
    }
  }
  if (!state.ok) {
    $0 = null;
    state.pos = $pos;
  }
  return $0;
}

String? digit0(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c >= 48 && c <= 57;
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = true;
  if (state.ok) {
    $0 = $pos == state.pos ? '' : source.substring($pos, state.pos);
  }
  return $0;
}

String? digit1(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c >= 48 && c <= 57;
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = state.pos != $pos;
  if (state.ok) {
    $0 = source.substring($pos, state.pos);
  } else if (state.log) {
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  return $0;
}

void eof(State<String> state) {
  final source = state.source;
  state.ok = state.pos >= source.length;
  if (!state.ok && state.log) {
    state.error = ErrExpected.eof(state.pos);
  }
}

int? escapeSequence16(State<String> state) {
  int? $0;
  final source = state.source;
  state.ok = state.pos < source.length;
  if (state.ok) {
    var c = source.codeUnitAt(state.pos);
    int? v;
    switch (c) {
      case 80:
        v = c;
        break;
      case 110:
        v = 10;
        break;
      case 114:
        v = 13;
        break;
    }
    state.ok = v != null;
    if (state.ok) {
      state.pos++;
      $0 = v;
    } else if (state.log) {
      state.error = ErrUnexpected.charAt(state.pos, source);
    }
  } else if (state.log) {
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
}

int? escapeSequence32(State<String> state) {
  int? $0;
  final source = state.source;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final pos = state.pos;
    var c = source.readRune(state);
    int? v;
    switch (c) {
      case 80:
      case 119296:
        v = c;
        break;
      case 110:
        v = 10;
        break;
      case 114:
        v = 13;
        break;
    }
    state.ok = v != null;
    if (state.ok) {
      $0 = v;
    } else {
      state.pos = pos;
      if (state.log) {
        state.error = ErrUnexpected.char(state.pos, Char(c));
      }
    }
  } else if (state.log) {
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
}

dynamic foldMany0Digit(State<String> state) {
  dynamic $0;
  final source = state.source;
  var $acc = 0;
  final $log = state.log;
  state.log = false;
  while (true) {
    int? $1;
    state.ok = state.pos < source.length;
    if (state.ok) {
      final c = source.codeUnitAt(state.pos);
      state.ok = c >= 48 && c <= 57;
      if (state.ok) {
        state.pos++;
        $1 = c;
      } else if (state.log) {
        state.error = ErrUnexpected.charAt(state.pos, source);
      }
    } else if (state.log) {
      state.error = ErrUnexpected.eof(state.pos);
    }
    if (!state.ok) {
      break;
    }
    final $v = $1!;
    $acc = $acc * 10 + $v - 0x30;
  }
  state.log = $log;
  state.ok = true;
  if (state.ok) {
    $0 = $acc;
  }
  return $0;
}

String? hexDigit0(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 102 &&
        (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102);
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = true;
  if (state.ok) {
    $0 = $pos == state.pos ? '' : source.substring($pos, state.pos);
  }
  return $0;
}

String? hexDigit1(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 102 &&
        (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102);
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = state.pos != $pos;
  if (state.ok) {
    $0 = source.substring($pos, state.pos);
  } else if (state.log) {
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  return $0;
}

String? identifier(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final c = source.codeUnitAt(state.pos++);
    state.ok = c <= 122 &&
        (c >= 48 && c <= 57 ||
            c >= 65 && c <= 90 ||
            c == 95 ||
            c >= 97 && c <= 122);
    if (state.ok) {
      while (state.pos < source.length) {
        final pos = state.pos;
        final c = source.codeUnitAt(state.pos++);
        state.ok = c <= 122 &&
            (c >= 48 && c <= 57 || c >= 65 && c <= 90 || c >= 97 && c <= 122);
        if (!state.ok) {
          state.pos = pos;
          break;
        }
      }
      state.ok = true;
      final text = source.slice($pos, state.pos);
      final length = text.length;
      final c = text.codeUnitAt(0);
      final words = const [
        ['else'],
        ['for', 'foreach'],
        ['if', 'in', 'int'],
        ['while']
      ];
      var index = -1;
      var min = 0;
      var max = words.length - 1;
      while (min <= max) {
        final mid = min + (max - min) ~/ 2;
        final x = words[mid][0].codeUnitAt(0);
        if (x == c) {
          index = mid;
          break;
        }
        if (x < c) {
          min = mid + 1;
        } else {
          max = mid - 1;
        }
      }
      if (index != -1) {
        final list = words[index];
        for (var i = list.length - 1; i >= 0; i--) {
          final v = list[i];
          if (length > v.length) {
            break;
          }
          if (length == v.length && text == v) {
            state.ok = false;
            break;
          }
        }
      }
      if (state.ok) {
        $0 = text;
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    if (state.log) {
      state.error = ErrExpected.tag(state.pos, const Tag('identifier'));
    }
  }
  return $0;
}

List<int>? many0C16(State<String> state) {
  List<int>? $0;
  final source = state.source;
  final $list = <int>[];
  final $log = state.log;
  state.log = false;
  while (true) {
    int? $1;
    state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 80;
    if (state.ok) {
      state.pos++;
      $1 = 80;
    } else if (state.log) {
      state.error = ErrExpected.char(state.pos, const Char(80));
    }
    if (!state.ok) {
      break;
    }
    $list.add($1!);
  }
  state.log = $log;
  state.ok = true;
  if (state.ok) {
    $0 = $list;
  }
  return $0;
}

List<int>? many0C32(State<String> state) {
  List<int>? $0;
  final $list = <int>[];
  final $log = state.log;
  state.log = false;
  while (true) {
    int? $1;
    $1 = char32(state);
    if (!state.ok) {
      break;
    }
    $list.add($1!);
  }
  state.log = $log;
  state.ok = true;
  if (state.ok) {
    $0 = $list;
  }
  return $0;
}

int? many0CountC32(State<String> state) {
  int? $0;
  var $count = 0;
  final $log = state.log;
  state.log = false;
  while (true) {
    char32(state);
    if (!state.ok) {
      break;
    }
    $count++;
  }
  state.log = $log;
  state.ok = true;
  if (state.ok) {
    $0 = $count;
  }
  return $0;
}

List<int>? many1C32(State<String> state) {
  List<int>? $0;
  var $list = <int>[];
  final $log = state.log;
  while (true) {
    int? $1;
    $1 = char32(state);
    if (!state.ok) {
      break;
    }
    state.log = false;
    $list.add($1!);
  }
  state.log = $log;
  state.ok = $list.isNotEmpty;
  if (state.ok) {
    $0 = $list;
  }
  return $0;
}

int? many1CountC32(State<String> state) {
  int? $0;
  var $count = 0;
  final $log = state.log;
  while (true) {
    char32(state);
    if (!state.ok) {
      break;
    }
    state.log = false;
    $count++;
  }
  state.log = $log;
  state.ok = $count != 0;
  if (state.ok) {
    $0 = $count;
  }
  return $0;
}

List<int>? manyMNC32_2_3(State<String> state) {
  List<int>? $0;
  final $pos = state.pos;
  final $list = <int>[];
  final $log = state.log;
  while ($list.length < 3) {
    if (state.log) {
      if ($list.length >= 2) {
        state.log = false;
      }
    }
    int? $1;
    $1 = char32(state);
    if (!state.ok) {
      break;
    }
    $list.add($1!);
  }
  state.log = $log;
  state.ok = $list.length >= 2;
  if (state.ok) {
    $0 = $list;
  } else {
    state.pos = $pos;
  }
  return $0;
}

List<int>? manyNC32_2(State<String> state) {
  List<int>? $0;
  final $pos = state.pos;
  final $list = <int>[];
  while ($list.length < 2) {
    int? $1;
    $1 = char32(state);
    if (!state.ok) {
      break;
    }
    $list.add($1!);
  }
  state.ok = $list.length == 2;
  if (state.ok) {
    $0 = $list;
  } else {
    state.pos = $pos;
  }
  return $0;
}

Tuple2<List<String>, String>? manyTillAOrBTillAbc(State<String> state) {
  Tuple2<List<String>, String>? $0;
  final source = state.source;
  final $pos = state.pos;
  final $list = <String>[];
  while (true) {
    String? $1;
    state.ok = state.pos < source.length &&
        source.codeUnitAt(state.pos) == 97 &&
        source.startsWith('abc', state.pos);
    if (state.ok) {
      state.pos += 3;
      $1 = 'abc';
    } else if (state.log) {
      state.error = ErrExpected.tag(state.pos, const Tag('abc'));
    }
    if (state.ok) {
      $0 = Tuple2($list, $1!);
      break;
    }
    final $error = state.error;
    String? $2;
    state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 97;
    if (state.ok) {
      state.pos += 1;
      $2 = 'a';
    } else if (state.log) {
      state.error = ErrExpected.tag(state.pos, const Tag('a'));
    }
    if (!state.ok) {
      final $3 = state.error;
      state.ok =
          state.pos < source.length && source.codeUnitAt(state.pos) == 98;
      if (state.ok) {
        state.pos += 1;
        $2 = 'b';
      } else if (state.log) {
        state.error = ErrExpected.tag(state.pos, const Tag('b'));
      }
      if (!state.ok) {
        final $4 = state.error;
        if (state.log) {
          state.error = ErrCombined(state.pos, [$3, $4]);
        }
      }
    }
    if (!state.ok) {
      if (state.log) {
        state.error = ErrCombined(state.pos, [$error, state.error]);
      }
      state.pos = $pos;
      break;
    }
    $list.add($2!);
  }
  return $0;
}

dynamic map4Digits(State<String> state) {
  dynamic $0;
  final source = state.source;
  final $pos = state.pos;
  int? $1;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final c = source.codeUnitAt(state.pos);
    state.ok = c >= 48 && c <= 57;
    if (state.ok) {
      state.pos++;
      $1 = c;
    } else if (state.log) {
      state.error = ErrUnexpected.charAt(state.pos, source);
    }
  } else if (state.log) {
    state.error = ErrUnexpected.eof(state.pos);
  }
  if (state.ok) {
    int? $2;
    state.ok = state.pos < source.length;
    if (state.ok) {
      final c = source.codeUnitAt(state.pos);
      state.ok = c >= 48 && c <= 57;
      if (state.ok) {
        state.pos++;
        $2 = c;
      } else if (state.log) {
        state.error = ErrUnexpected.charAt(state.pos, source);
      }
    } else if (state.log) {
      state.error = ErrUnexpected.eof(state.pos);
    }
    if (state.ok) {
      int? $3;
      state.ok = state.pos < source.length;
      if (state.ok) {
        final c = source.codeUnitAt(state.pos);
        state.ok = c >= 48 && c <= 57;
        if (state.ok) {
          state.pos++;
          $3 = c;
        } else if (state.log) {
          state.error = ErrUnexpected.charAt(state.pos, source);
        }
      } else if (state.log) {
        state.error = ErrUnexpected.eof(state.pos);
      }
      if (state.ok) {
        int? $4;
        state.ok = state.pos < source.length;
        if (state.ok) {
          final c = source.codeUnitAt(state.pos);
          state.ok = c >= 48 && c <= 57;
          if (state.ok) {
            state.pos++;
            $4 = c;
          } else if (state.log) {
            state.error = ErrUnexpected.charAt(state.pos, source);
          }
        } else if (state.log) {
          state.error = ErrUnexpected.eof(state.pos);
        }
        if (state.ok) {
          final v1 = $1!;
          final v2 = $2!;
          final v3 = $3!;
          final v4 = $4!;
          $0 = (v1 - 0x30) * 1000 +
              (v2 - 0x30) * 100 +
              (v3 - 0x30) * 10 +
              v4 -
              0x30;
        }
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

String? mapC32ToStr(State<String> state) {
  String? $0;
  final source = state.source;
  int? $1;
  state.ok = state.pos < source.length && source.runeAt(state.pos) == 119296;
  if (state.ok) {
    state.pos += 2;
    $1 = 119296;
  } else if (state.log) {
    state.error = ErrExpected.char(state.pos, const Char(119296));
  }
  if (state.ok) {
    final v = $1!;
    $0 = String.fromCharCode(v);
  }
  return $0;
}

int? noneOfC16(State<String> state) {
  int? $0;
  final source = state.source;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final pos = state.pos;
    final c = source.readRune(state);
    state.ok = c != 80;
    if (state.ok) {
      $0 = c;
    } else {
      state.pos = pos;
      if (state.log) {
        state.error = ErrUnexpected.char(state.pos, Char(c));
      }
    }
  } else if (state.log) {
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
}

int? noneOfOfC16OrC32(State<String> state) {
  int? $0;
  final source = state.source;
  final $calculate = state.context.listOfC16AndC32 as List<int>;
  if (state.pos < source.length) {
    List<int>? $1;
    state.ok = true;
    if (state.ok) {
      $1 = $calculate;
    }
    if (state.ok) {
      final pos = state.pos;
      var c = source.readRune(state);
      final list = $1!;
      for (var i = 0; i < list.length; i++) {
        final ch = list[i];
        if (c == ch) {
          state.pos = pos;
          state.ok = false;
          if (state.log) {
            state.error = ErrUnexpected.char(state.pos, Char(c));
          }
          break;
        }
      }
      if (state.ok) {
        $0 = c;
      }
    }
  } else {
    if (state.log) {
      state.error = ErrUnexpected.eof(state.pos);
    }
    state.ok = false;
  }
  return $0;
}

int? noneOfC32(State<String> state) {
  int? $0;
  final source = state.source;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final pos = state.pos;
    final c = source.readRune(state);
    state.ok = c != 119296;
    if (state.ok) {
      $0 = c;
    } else {
      state.pos = pos;
      if (state.log) {
        state.error = ErrUnexpected.char(state.pos, Char(c));
      }
    }
  } else if (state.log) {
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
}

void noneOfTagsAbcAbdDefDegXXY(State<String> state) {
  final source = state.source;
  state.ok = true;
  if (state.pos < source.length) {
    final pos = state.pos;
    final c = source.codeUnitAt(pos);
    switch (c) {
      case 97:
        if (source.startsWith('abc', pos)) {
          state.ok = false;
          if (state.log) {
            state.error = ErrUnexpected.tag(pos, const Tag('abc'));
          }
          break;
        }
        if (source.startsWith('abd', pos)) {
          state.ok = false;
          if (state.log) {
            state.error = ErrUnexpected.tag(pos, const Tag('abd'));
          }
          break;
        }
        break;
      case 100:
        if (source.startsWith('def', pos)) {
          state.ok = false;
          if (state.log) {
            state.error = ErrUnexpected.tag(pos, const Tag('def'));
          }
          break;
        }
        if (source.startsWith('deg', pos)) {
          state.ok = false;
          if (state.log) {
            state.error = ErrUnexpected.tag(pos, const Tag('deg'));
          }
          break;
        }
        break;
      case 120:
        if (source.startsWith('xy', pos)) {
          state.ok = false;
          if (state.log) {
            state.error = ErrUnexpected.tag(pos, const Tag('xy'));
          }
          break;
        }
        state.ok = false;
        if (state.log) {
          state.error = ErrUnexpected.tag(pos, const Tag('x'));
        }
        break;
    }
  }
}

void notC32OrC16(State<String> state) {
  final $pos = state.pos;
  final $log = state.log;
  state.log = false;
  char16(state);
  if (!state.ok) {
    final $1 = state.error;
    char32(state);
    if (!state.ok) {
      final $2 = state.error;
      if (state.log) {
        state.error = ErrCombined(state.pos, [$1, $2]);
      }
    }
  }
  state.log = $log;
  state.ok = !state.ok;
  if (!state.ok) {
    state.pos = $pos;
    if ($log) {
      state.error = ErrUnknown(state.pos);
    }
  }
}

int? oneOfC16(State<String> state) {
  int? $0;
  final source = state.source;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final c = source.codeUnitAt(state.pos);
    state.ok = c == 80;
    if (state.ok) {
      state.pos++;
      $0 = c;
    } else if (state.log) {
      state.error = ErrUnexpected.charAt(state.pos, source);
    }
  } else if (state.log) {
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
}

int? oneOfC32(State<String> state) {
  int? $0;
  final source = state.source;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final pos = state.pos;
    final c = source.readRune(state);
    state.ok = c == 119296;
    if (state.ok) {
      $0 = c;
    } else {
      state.pos = pos;
      if (state.log) {
        state.error = ErrUnexpected.char(state.pos, Char(c));
      }
    }
  } else if (state.log) {
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
}

String? optAbc(State<String> state) {
  String? $0;
  final source = state.source;
  final $log = state.log;
  state.log = false;
  state.ok = state.pos < source.length &&
      source.codeUnitAt(state.pos) == 97 &&
      source.startsWith('abc', state.pos);
  if (state.ok) {
    state.pos += 3;
    $0 = 'abc';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('abc'));
  }
  state.log = $log;
  if (!state.ok) {
    state.ok = true;
  }
  return $0;
}

Tuple2<int, int>? pairC16C32(State<String> state) {
  Tuple2<int, int>? $0;
  final $pos = state.pos;
  int? $1;
  $1 = char16(state);
  if (state.ok) {
    int? $2;
    $2 = char32(state);
    if (state.ok) {
      $0 = Tuple2($1!, $2!);
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

int? peekC32(State<String> state) {
  int? $0;
  final $pos = state.pos;
  int? $1;
  $1 = char32(state);
  if (state.ok) {
    state.pos = $pos;
    $0 = $1!;
  }
  return $0;
}

int? postfixExpression(State<String> state) {
  int? $0;
  final source = state.source;
  int? $1;
  $1 = _primaryExpression(state);
  if (state.ok) {
    String? $2;
    final $log = state.log;
    state.log = false;
    state.ok = state.pos < source.length;
    if (state.ok) {
      final pos = state.pos;
      final c = source.codeUnitAt(pos);
      String? v;
      switch (c) {
        case 45:
          if (source.startsWith('--', pos)) {
            state.pos += 2;
            v = '--';
            break;
          }
          break;
        case 43:
          if (source.startsWith('++', pos)) {
            state.pos += 2;
            v = '++';
            break;
          }
          break;
      }
      state.ok = v != null;
      if (state.ok) {
        $2 = v;
      }
    }
    if (!state.ok && state.log) {
      state.error = ErrCombined(state.pos, [
        ErrExpected.tag(state.pos, const Tag('--')),
        ErrExpected.tag(state.pos, const Tag('++'))
      ]);
    }
    state.log = $log;
    if (!state.ok) {
      state.ok = true;
    }
    if ($2 != null) {
      final v1 = $1!;
      final v2 = $2;
      $0 = _toPostfix(v1, v2);
    } else {
      $0 = $1!;
    }
  }
  return $0;
}

int? prefixExpression(State<String> state) {
  int? $0;
  final source = state.source;
  String? $1;
  final $log = state.log;
  state.log = false;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final pos = state.pos;
    final c = source.codeUnitAt(pos);
    String? v;
    switch (c) {
      case 45:
        if (source.startsWith('--', pos)) {
          state.pos += 2;
          v = '--';
          break;
        }
        state.pos++;
        v = '-';
        break;
      case 43:
        if (source.startsWith('++', pos)) {
          state.pos += 2;
          v = '++';
          break;
        }
        break;
    }
    state.ok = v != null;
    if (state.ok) {
      $1 = v;
    }
  }
  if (!state.ok && state.log) {
    state.error = ErrCombined(state.pos, [
      ErrExpected.tag(state.pos, const Tag('-')),
      ErrExpected.tag(state.pos, const Tag('--')),
      ErrExpected.tag(state.pos, const Tag('++'))
    ]);
  }
  state.log = $log;
  if (!state.ok) {
    state.ok = true;
  }
  int? $2;
  $2 = _primaryExpression(state);
  if (state.ok) {
    if ($1 != null) {
      final v1 = $1;
      final v2 = $2!;
      $0 = _toPrefix(v1, v2);
    } else {
      $0 = $2!;
    }
  }
  return $0;
}

int? precededC16C32(State<String> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  char16(state);
  if (state.ok) {
    state.ok = state.pos < source.length && source.runeAt(state.pos) == 119296;
    if (state.ok) {
      state.pos += 2;
      $0 = 119296;
    } else if (state.log) {
      state.error = ErrExpected.char(state.pos, const Char(119296));
    }
  }
  if (!state.ok) {
    $0 = null;
    state.pos = $pos;
  }
  return $0;
}

String? recognize3C32AbcC16(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  final $pos1 = state.pos;
  char32(state);
  if (state.ok) {
    tagAbc(state);
    if (state.ok) {
      char16(state);
      if (state.ok) {
        //
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos1;
  }
  if (state.ok) {
    $0 = source.slice($pos, state.pos);
  }
  return $0;
}

int? satisfyC16(State<String> state) {
  int? $0;
  final source = state.source;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final c = source.codeUnitAt(state.pos);
    state.ok = c == 80;
    if (state.ok) {
      state.pos++;
      $0 = c;
    } else if (state.log) {
      state.error = ErrUnexpected.charAt(state.pos, source);
    }
  } else if (state.log) {
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
}

int? satisfyC32(State<String> state) {
  int? $0;
  final source = state.source;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final pos = state.pos;
    final c = source.readRune(state);
    state.ok = c == 119296;
    if (state.ok) {
      $0 = c;
    } else {
      state.pos = pos;
      if (state.log) {
        state.error = ErrUnexpected.char(state.pos, Char(c));
      }
    }
  } else if (state.log) {
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
}

List<int>? separatedList0C32Abc(State<String> state) {
  List<int>? $0;
  final source = state.source;
  var $pos = state.pos;
  final $list = <int>[];
  final $log = state.log;
  state.log = false;
  while (true) {
    int? $1;
    state.ok = state.pos < source.length && source.runeAt(state.pos) == 119296;
    if (state.ok) {
      state.pos += 2;
      $1 = 119296;
    } else if (state.log) {
      state.error = ErrExpected.char(state.pos, const Char(119296));
    }
    if (!state.ok) {
      state.pos = $pos;
      break;
    }
    $list.add($1!);
    $pos = state.pos;
    state.ok = state.pos < source.length &&
        source.codeUnitAt(state.pos) == 97 &&
        source.startsWith('abc', state.pos);
    if (state.ok) {
      state.pos += 3;
    } else if (state.log) {
      state.error = ErrExpected.tag(state.pos, const Tag('abc'));
    }
    if (!state.ok) {
      break;
    }
  }
  state.log = $log;
  state.ok = true;
  if (state.ok) {
    $0 = $list;
  }
  return $0;
}

List<int>? separatedList1C32Abc(State<String> state) {
  List<int>? $0;
  final source = state.source;
  var $pos = state.pos;
  final $list = <int>[];
  final $log = state.log;
  while (true) {
    int? $1;
    state.ok = state.pos < source.length && source.runeAt(state.pos) == 119296;
    if (state.ok) {
      state.pos += 2;
      $1 = 119296;
    } else if (state.log) {
      state.error = ErrExpected.char(state.pos, const Char(119296));
    }
    if (!state.ok) {
      state.pos = $pos;
      break;
    }
    state.log = false;
    $list.add($1!);
    $pos = state.pos;
    state.ok = state.pos < source.length &&
        source.codeUnitAt(state.pos) == 97 &&
        source.startsWith('abc', state.pos);
    if (state.ok) {
      state.pos += 3;
    } else if (state.log) {
      state.error = ErrExpected.tag(state.pos, const Tag('abc'));
    }
    if (!state.ok) {
      break;
    }
  }
  state.log = $log;
  state.ok = $list.isNotEmpty;
  if (state.ok) {
    $0 = $list;
  }
  return $0;
}

List<int>? separatedListN_2C32Abc(State<String> state) {
  List<int>? $0;
  final source = state.source;
  final $pos = state.pos;
  var $last = $pos;
  final $list = <int>[];
  while (true) {
    int? $1;
    state.ok = state.pos < source.length && source.runeAt(state.pos) == 119296;
    if (state.ok) {
      state.pos += 2;
      $1 = 119296;
    } else if (state.log) {
      state.error = ErrExpected.char(state.pos, const Char(119296));
    }
    if (!state.ok) {
      state.pos = $last;
      break;
    }
    $list.add($1!);
    if ($list.length == 2) {
      break;
    }
    $last = state.pos;
    state.ok = state.pos < source.length &&
        source.codeUnitAt(state.pos) == 97 &&
        source.startsWith('abc', state.pos);
    if (state.ok) {
      state.pos += 3;
    } else if (state.log) {
      state.error = ErrExpected.tag(state.pos, const Tag('abc'));
    }
    if (!state.ok) {
      break;
    }
  }
  state.ok = $list.length == 2;
  if (state.ok) {
    $0 = $list;
  } else {
    state.pos = $pos;
  }
  return $0;
}

Tuple2<int, int>? separatedPairC16AbcC32(State<String> state) {
  Tuple2<int, int>? $0;
  final source = state.source;
  final $pos = state.pos;
  int? $1;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 80;
  if (state.ok) {
    state.pos++;
    $1 = 80;
  } else if (state.log) {
    state.error = ErrExpected.char(state.pos, const Char(80));
  }
  if (state.ok) {
    state.ok = state.pos < source.length &&
        source.codeUnitAt(state.pos) == 97 &&
        source.startsWith('abc', state.pos);
    if (state.ok) {
      state.pos += 3;
    } else if (state.log) {
      state.error = ErrExpected.tag(state.pos, const Tag('abc'));
    }
    if (state.ok) {
      int? $2;
      state.ok =
          state.pos < source.length && source.runeAt(state.pos) == 119296;
      if (state.ok) {
        state.pos += 2;
        $2 = 119296;
      } else if (state.log) {
        state.error = ErrExpected.char(state.pos, const Char(119296));
      }
      if (state.ok) {
        $0 = Tuple2($1!, $2!);
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

void skipWhile1C16(State<String> state) {
  final source = state.source;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c == 80;
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = state.pos != $pos;
  if (!state.ok && state.log) {
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
}

void skipWhile1C32(State<String> state) {
  final source = state.source;
  final $pos = state.pos;
  int? $c;
  while (state.pos < source.length) {
    final pos = state.pos;
    $c = source.readRune(state);
    final ok = $c == 119296;
    if (!ok) {
      state.pos = pos;
      break;
    }
  }
  state.ok = state.pos != $pos;
  if (!state.ok && state.log) {
    state.error = ErrUnexpected.charOrEof(state.pos, source, $c);
  }
}

void skipWhileC16(State<String> state) {
  final source = state.source;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c == 80;
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = true;
}

void skipWhileC32(State<String> state) {
  final source = state.source;
  while (state.pos < source.length) {
    final pos = state.pos;
    final c = source.readRune(state);
    final ok = c == 119296;
    if (!ok) {
      state.pos = pos;
      break;
    }
  }
  state.ok = true;
}

String? stringValue(State<String> state) {
  String? $0;
  final source = state.source;
  state.ok = true;
  final $pos = state.pos;
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
    int? $1;
    state.ok = state.pos < source.length;
    if (state.ok) {
      var c = source.codeUnitAt(state.pos);
      int? v;
      switch (c) {
        case 110:
          v = 10;
          break;
      }
      state.ok = v != null;
      if (state.ok) {
        state.pos++;
        $1 = v;
      } else if (state.log) {
        state.error = ErrUnexpected.charAt(state.pos, source);
      }
    } else if (state.log) {
      state.error = ErrUnexpected.eof(state.pos);
    }
    if (!state.ok) {
      state.pos = $pos;
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
  return $0;
}

String? tagC16(State<String> state) {
  String? $0;
  final source = state.source;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 80;
  if (state.ok) {
    state.pos += 1;
    $0 = 'P';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('P'));
  }
  return $0;
}

String? tagC16C32(State<String> state) {
  String? $0;
  final source = state.source;
  state.ok = state.pos < source.length &&
      source.codeUnitAt(state.pos) == 80 &&
      source.startsWith('P𝈀', state.pos);
  if (state.ok) {
    state.pos += 3;
    $0 = 'P𝈀';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('P𝈀'));
  }
  return $0;
}

String? tagC32(State<String> state) {
  String? $0;
  final source = state.source;
  state.ok = state.pos + 1 < source.length &&
      source.codeUnitAt(state.pos) == 55348 &&
      source.codeUnitAt(state.pos + 1) == 56832;
  if (state.ok) {
    state.pos += 2;
    $0 = '𝈀';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('𝈀'));
  }
  return $0;
}

String? tagC32C16(State<String> state) {
  String? $0;
  final source = state.source;
  state.ok = state.pos < source.length &&
      source.codeUnitAt(state.pos) == 55348 &&
      source.startsWith('𝈀P', state.pos);
  if (state.ok) {
    state.pos += 3;
    $0 = '𝈀P';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('𝈀P'));
  }
  return $0;
}

String? tagOfFoo(State<String> state) {
  String? $0;
  final source = state.source;
  final $calculate = state.context.foo as String;
  String? $1;
  state.ok = true;
  if (state.ok) {
    $1 = $calculate;
  }
  if (state.ok) {
    final tag = $1!;
    state.ok = source.startsWith(tag, state.pos);
    if (state.ok) {
      state.pos += tag.length;
      $0 = tag;
    } else if (state.log) {
      state.error = ErrExpected.tag(state.pos, Tag(tag));
    }
  }
  return $0;
}

String? tagNoCaseAbc(State<String> state) {
  String? $0;
  final source = state.source;
  final $start = state.pos;
  final $end = $start + 3;
  state.ok = $end <= source.length;
  if (state.ok) {
    final v = source.substring($start, $end);
    state.ok = v.toLowerCase() == 'abc';
    if (state.ok) {
      state.pos = $end;
      $0 = v;
    }
  }
  if (!state.ok && state.log) {
    state.error = ErrExpected.tag($start, const Tag('abc'));
  }
  return $0;
}

String? tagsAbcAbdDefDegXXY(State<String> state) {
  String? $0;
  final source = state.source;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final pos = state.pos;
    final c = source.codeUnitAt(pos);
    String? v;
    switch (c) {
      case 97:
        if (source.startsWith('abc', pos)) {
          state.pos += 3;
          v = 'abc';
          break;
        }
        if (source.startsWith('abd', pos)) {
          state.pos += 3;
          v = 'abd';
          break;
        }
        break;
      case 100:
        if (source.startsWith('def', pos)) {
          state.pos += 3;
          v = 'def';
          break;
        }
        if (source.startsWith('deg', pos)) {
          state.pos += 3;
          v = 'deg';
          break;
        }
        break;
      case 120:
        if (source.startsWith('xy', pos)) {
          state.pos += 2;
          v = 'xy';
          break;
        }
        state.pos++;
        v = 'x';
        break;
    }
    state.ok = v != null;
    if (state.ok) {
      $0 = v;
    }
  }
  if (!state.ok && state.log) {
    state.error = ErrCombined(state.pos, [
      ErrExpected.tag(state.pos, const Tag('abc')),
      ErrExpected.tag(state.pos, const Tag('abd')),
      ErrExpected.tag(state.pos, const Tag('def')),
      ErrExpected.tag(state.pos, const Tag('deg')),
      ErrExpected.tag(state.pos, const Tag('x')),
      ErrExpected.tag(state.pos, const Tag('xy'))
    ]);
  }
  return $0;
}

String? takeUntilAbc(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  final $index = source.indexOf('abc', $pos);
  state.ok = $index >= 0;
  if (state.ok) {
    state.pos = $index;
    $0 = source.substring($pos, $index);
  } else if (state.log) {
    state.error = ErrExpected.tag($pos, const Tag('abc'));
  }
  return $0;
}

String? takeUntil1Abc(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  final $index = source.indexOf('abc', $pos);
  state.ok = $index > $pos;
  if (state.ok) {
    state.pos = $index;
    $0 = source.substring($pos, $index);
  } else if (state.log) {
    if ($index == -1) {
      state.error = ErrExpected.tag(source.length, const Tag('abc'));
    } else {
      state.error = ErrUnexpected.tag($pos, const Tag('abc'));
    }
  }
  return $0;
}

String? takeWhile1C16(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c == 80;
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = state.pos != $pos;
  if (state.ok) {
    $0 = source.substring($pos, state.pos);
  } else if (state.log) {
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  return $0;
}

String? takeWhile1C32(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  int? $c;
  while (state.pos < source.length) {
    final pos = state.pos;
    $c = source.readRune(state);
    final ok = $c == 119296;
    if (!ok) {
      state.pos = pos;
      break;
    }
  }
  state.ok = state.pos != $pos;
  if (state.ok) {
    $0 = source.substring($pos, state.pos);
  } else if (state.log) {
    state.error = ErrUnexpected.charOrEof($pos, source, $c);
  }
  return $0;
}

String? takeWhileC16(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c == 80;
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = true;
  if (state.ok) {
    $0 = $pos == state.pos ? '' : source.substring($pos, state.pos);
  }
  return $0;
}

String? takeWhileC32(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final pos = state.pos;
    final c = source.readRune(state);
    final ok = c == 119296;
    if (!ok) {
      state.pos = pos;
      break;
    }
  }
  state.ok = true;
  if (state.ok) {
    $0 = $pos == state.pos ? '' : source.substring($pos, state.pos);
  }
  return $0;
}

String? takeWhileMN_2_4C16(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  var $count = 0;
  while ($count < 4 && state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c == 80;
    if (!ok) {
      break;
    }
    state.pos++;
    $count++;
  }
  state.ok = $count >= 2;
  if (state.ok) {
    $0 = source.substring($pos, state.pos);
  } else {
    if (state.log) {
      state.error = ErrUnexpected.charOrEof(state.pos, source);
    }
    state.pos = $pos;
  }
  return $0;
}

String? takeWhileMN_2_4C32(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  int? $c;
  var $count = 0;
  while ($count < 4 && state.pos < source.length) {
    final pos = state.pos;
    $c = source.readRune(state);
    final ok = $c == 119296;
    if (!ok) {
      state.pos = pos;
      break;
    }
    $count++;
  }
  state.ok = $count >= 2;
  if (state.ok) {
    $0 = source.substring($pos, state.pos);
  } else {
    if (state.log) {
      state.error = ErrUnexpected.charOrEof(state.pos, source, $c);
    }
    state.pos = $pos;
  }
  return $0;
}

int? terminated(State<String> state) {
  int? $0;
  final $pos = state.pos;
  $0 = char16(state);
  if (state.ok) {
    char32(state);
  }
  if (!state.ok) {
    $0 = null;
    state.pos = $pos;
  }
  return $0;
}

int? testRef(State<String> state) {
  int? $0;
  $0 = char16(state);
  return $0;
}

Tuple2<int, String>? tuple2C32Abc(State<String> state) {
  Tuple2<int, String>? $0;
  final $pos = state.pos;
  int? $1;
  $1 = char32(state);
  if (state.ok) {
    String? $2;
    $2 = tagAbc(state);
    if (state.ok) {
      $0 = Tuple2($1!, $2!);
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

Tuple3<int, String, int>? tuple3C32AbcC16(State<String> state) {
  Tuple3<int, String, int>? $0;
  final source = state.source;
  final $pos = state.pos;
  int? $1;
  $1 = char32(state);
  if (state.ok) {
    String? $2;
    $2 = tagAbc(state);
    if (state.ok) {
      int? $3;
      state.ok =
          state.pos < source.length && source.codeUnitAt(state.pos) == 80;
      if (state.ok) {
        state.pos++;
        $3 = 80;
      } else if (state.log) {
        state.error = ErrExpected.char(state.pos, const Char(80));
      }
      if (state.ok) {
        $0 = Tuple3($1!, $2!, $3!);
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

bool? valueAbcToTrueValue(State<String> state) {
  bool? $0;
  final source = state.source;
  state.ok = state.pos < source.length &&
      source.codeUnitAt(state.pos) == 97 &&
      source.startsWith('abc', state.pos);
  if (state.ok) {
    state.pos += 3;
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('abc'));
  }
  if (state.ok) {
    $0 = true;
  }
  return $0;
}

bool? valueTrue(State<dynamic> state) {
  bool? $0;
  state.ok = true;
  if (state.ok) {
    $0 = true;
  }
  return $0;
}

String? transformersCharClassIsDigit(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c >= 48 && c <= 57;
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = true;
  if (state.ok) {
    $0 = $pos == state.pos ? '' : source.substring($pos, state.pos);
  }
  return $0;
}

String? transformersExprIsDigit(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final pos = state.pos;
    final c = source.readRune(state);
    final ok = c >= 0x30 && c <= 0x39;
    if (!ok) {
      state.pos = pos;
      break;
    }
  }
  state.ok = true;
  if (state.ok) {
    $0 = $pos == state.pos ? '' : source.substring($pos, state.pos);
  }
  return $0;
}

String? transformersFuncIsDigit(State<String> state) {
  String? $0;
  final source = state.source;
  bool $test(int x) {
    return x >= 0x30 && x <= 0x39;
  }

  final $pos = state.pos;
  while (state.pos < source.length) {
    final pos = state.pos;
    final c = source.readRune(state);
    final ok = $test(c);
    if (!ok) {
      state.pos = pos;
      break;
    }
  }
  state.ok = true;
  if (state.ok) {
    $0 = $pos == state.pos ? '' : source.substring($pos, state.pos);
  }
  return $0;
}

String? transformersNotCharClassIsDigit(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final pos = state.pos;
    final c = source.readRune(state);
    final ok = c > 1114111 || !(c >= 0 && c <= 47 || c >= 58 && c <= 1114111);
    if (!ok) {
      state.pos = pos;
      break;
    }
  }
  state.ok = true;
  if (state.ok) {
    $0 = $pos == state.pos ? '' : source.substring($pos, state.pos);
  }
  return $0;
}

int? transformersVarIsNotDigit(State<String> state) {
  int? $0;
  final source = state.source;
  final $calculate = const [
    0x30,
    0x31,
    0x32,
    0x33,
    0x34,
    0x35,
    0x36,
    0x37,
    0x38,
    0x39
  ];
  if (state.pos < source.length) {
    List<int>? $1;
    state.ok = true;
    if (state.ok) {
      $1 = $calculate;
    }
    if (state.ok) {
      final pos = state.pos;
      var c = source.readRune(state);
      final list = $1!;
      for (var i = 0; i < list.length; i++) {
        final ch = list[i];
        if (c == ch) {
          state.pos = pos;
          state.ok = false;
          if (state.log) {
            state.error = ErrUnexpected.char(state.pos, Char(c));
          }
          break;
        }
      }
      if (state.ok) {
        $0 = c;
      }
    }
  } else {
    if (state.log) {
      state.error = ErrUnexpected.eof(state.pos);
    }
    state.ok = false;
  }
  return $0;
}

String? verifyIs3Digit(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  String? $1;
  final $pos1 = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c >= 48 && c <= 57;
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = true;
  if (state.ok) {
    $1 = $pos1 == state.pos ? '' : source.substring($pos1, state.pos);
  }
  if (state.ok) {
    final v = $1!;
    state.ok = v.length == 3;
    if (state.ok) {
      $0 = v;
    } else {
      if (state.log) {
        state.error = ErrMessage($pos, state.pos - $pos, 'Message');
      }
      state.pos = $pos;
    }
  }
  return $0;
}

void verifyIs3DigitFast(State<String> state) {
  final source = state.source;
  final $pos = state.pos;
  String? $1;
  final $pos1 = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c >= 48 && c <= 57;
    if (!ok) {
      break;
    }
    state.pos++;
  }
  state.ok = true;
  if (state.ok) {
    $1 = $pos1 == state.pos ? '' : source.substring($pos1, state.pos);
  }
  if (state.ok) {
    final v = $1!;
    state.ok = v.length == 3;
    if (!state.ok) {
      if (state.log) {
        state.error = ErrMessage($pos, state.pos - $pos, 'Message');
      }
      state.pos = $pos;
    }
  }
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
