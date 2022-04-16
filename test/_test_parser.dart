// ignore_for_file: unnecessary_cast

import 'package:tuple/tuple.dart';

String? alpha0(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.codeUnitAt(state.pos++));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v <= 122 && ($v >= 65 && $v <= 90 || $v >= 97 && $v <= 122);
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
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

String? alpha1(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  var $ok = false;
  while (true) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.codeUnitAt(state.pos++));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v <= 122 && ($v >= 65 && $v <= 90 || $v >= 97 && $v <= 122);
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
    }
    if (state.ok) {
      $ok = true;
    } else {
      break;
    }
  }
  state.ok = $ok;
  if (state.ok) {
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

String? alphanumeric0(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.codeUnitAt(state.pos++));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v <= 122 &&
          ($v >= 48 && $v <= 57 ||
              $v >= 65 && $v <= 90 ||
              $v >= 97 && $v <= 122);
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
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

String? alphanumeric1(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  var $ok = false;
  while (true) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.codeUnitAt(state.pos++));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v <= 122 &&
          ($v >= 48 && $v <= 57 ||
              $v >= 65 && $v <= 90 ||
              $v >= 97 && $v <= 122);
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
    }
    if (state.ok) {
      $ok = true;
    } else {
      break;
    }
  }
  state.ok = $ok;
  if (state.ok) {
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

int? char16(State<String> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $0 = _wrap(source.codeUnitAt(state.pos++));
  }
  if (state.ok) {
    final $v = _unwrap($0);
    state.ok = $v == 80;
    if (!state.ok) {
      $0 = null;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrExpected.char(state.pos, const Char(80));
  }
  return $0;
}

int? altC16OrC32(State<String> state) {
  int? $0;
  final source = state.source;
  $0 = char16(state);
  if (!state.ok) {
    final $error = state.error;
    final $pos = state.pos;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $0 = _wrap(source.readRune(state));
    }
    if (state.ok) {
      final $v = _unwrap($0);
      state.ok = $v == 119296;
      if (!state.ok) {
        $0 = null;
      }
    }
    if (!state.ok) {
      state.pos = $pos;
      state.error = ErrExpected.char(state.pos, const Char(119296));
    }
    if (!state.ok) {
      state.error = ErrCombined(state.pos, [$error, state.error]);
    }
  }
  return $0;
}

int? char32(State<String> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $0 = _wrap(source.readRune(state));
  }
  if (state.ok) {
    final $v = _unwrap($0);
    state.ok = $v == 119296;
    if (!state.ok) {
      $0 = null;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrExpected.char(state.pos, const Char(119296));
  }
  return $0;
}

void andC32OrC16(State<String> state) {
  final $pos = state.pos;
  char32(state);
  if (!state.ok) {
    final $error = state.error;
    char16(state);
    if (!state.ok) {
      state.error = ErrCombined(state.pos, [$error, state.error]);
    }
  }
  if (state.ok) {
    state.pos = $pos;
  }
}

int? anyChar(State<String> state) {
  int? $0;
  final source = state.source;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $0 = _wrap(source.readRune(state));
  } else {
    state.error = ErrUnexpected.eof(state.pos);
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
    $0 = _wrap('abc');
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('abc'));
  }
  return $0;
}

Tuple2<String, List<String>>? consumedSeparatedAbcC32(State<String> state) {
  Tuple2<String, List<String>>? $0;
  final source = state.source;
  final $pos = state.pos;
  String? $1;
  List<String>? $3;
  final $list = <String>[];
  var $pos1 = state.pos;
  while (true) {
    String? $4;
    $4 = tagAbc(state);
    if (state.ok) {
      $list.add(_unwrap($4));
    } else {
      state.pos = $pos1;
      break;
    }
    $pos1 = state.pos;
    char32(state);
    if (!state.ok) {
      break;
    }
  }
  state.ok = $list.isNotEmpty;
  if (state.ok) {
    $3 = _wrap($list);
  }
  if (state.ok) {
    $1 = _wrap(source.slice($pos, state.pos));
  }
  if (state.ok) {
    List<String>? $6;
    state.ok = true;
    $6 = $3;
    if (state.ok) {
      $0 = _wrap(Tuple2(_unwrap($1), _unwrap($6)));
    } else {
      state.pos = $pos;
    }
  }
  return $0;
}

int? delimited(State<String> state) {
  int? $0;
  final $pos = state.pos;
  char16(state);
  if (state.ok) {
    int? $2;
    $2 = char32(state);
    if (state.ok) {
      char16(state);
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

String? digit0(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.codeUnitAt(state.pos++));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v >= 48 && $v <= 57;
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
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

String? digit1(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  var $ok = false;
  while (true) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.codeUnitAt(state.pos++));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v >= 48 && $v <= 57;
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
    }
    if (state.ok) {
      $ok = true;
    } else {
      break;
    }
  }
  state.ok = $ok;
  if (state.ok) {
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

void eof(State<String> state) {
  final source = state.source;
  state.ok = state.pos >= source.length;
  if (!state.ok) {
    state.error = ErrExpected.eof(state.pos);
  }
}

int? escapeSequence16(State<String> state) {
  int? $0;
  final source = state.source;
  int? $c;
  state.ok = false;
  if (state.pos < source.length) {
    $c = source.codeUnitAt(state.pos);
    int? $v;
    switch ($c) {
      case 80:
        $v = $c;
        break;
      case 110:
        $v = 10;
        break;
      case 114:
        $v = 13;
        break;
    }
    if ($v != null) {
      state.pos++;
      state.ok = true;
      $0 = _wrap($v);
    }
  }
  if (!state.ok) {
    state.error = $c == null
        ? ErrUnexpected.eof(state.pos)
        : ErrUnexpected.charAt(state.pos, source);
  }
  return $0;
}

int? escapeSequence32(State<String> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  int? $c;
  state.ok = false;
  if (state.pos < source.length) {
    $c = source.readRune(state);
    int? $v;
    switch ($c) {
      case 80:
      case 119296:
        $v = $c;
        break;
      case 110:
        $v = 10;
        break;
      case 114:
        $v = 13;
        break;
    }
    if ($v != null) {
      state.ok = true;
      $0 = _wrap($v);
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = $c == null
        ? ErrUnexpected.eof(state.pos)
        : ErrUnexpected.char(state.pos, Char($c));
  }
  return $0;
}

dynamic foldMany0Digit(State<String> state) {
  dynamic $0;
  final source = state.source;
  var $acc = 0;
  while (true) {
    int? $1;
    final $pos = state.pos;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $1 = _wrap(source.codeUnitAt(state.pos++));
    }
    if (state.ok) {
      final $v = _unwrap($1);
      state.ok = $v >= 48 && $v <= 57;
      if (!state.ok) {
        $1 = null;
      }
    }
    if (!state.ok) {
      state.pos = $pos;
    }
    if (state.ok) {
      final $v1 = _unwrap($1);
      $acc = $acc * 10 + $v1 - 0x30;
    } else {
      break;
    }
  }
  state.ok = true;
  $0 = _wrap($acc);
  return $0;
}

String? hexDigit0(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.codeUnitAt(state.pos++));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v <= 102 &&
          ($v >= 48 && $v <= 57 ||
              $v >= 65 && $v <= 70 ||
              $v >= 97 && $v <= 102);
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
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

String? hexDigit1(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  var $ok = false;
  while (true) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.codeUnitAt(state.pos++));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v <= 102 &&
          ($v >= 48 && $v <= 57 ||
              $v >= 65 && $v <= 70 ||
              $v >= 97 && $v <= 102);
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
    }
    if (state.ok) {
      $ok = true;
    } else {
      break;
    }
  }
  state.ok = $ok;
  if (state.ok) {
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

List<int>? many0C16(State<String> state) {
  List<int>? $0;
  final source = state.source;
  final $list = <int>[];
  while (true) {
    int? $1;
    final $pos = state.pos;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $1 = _wrap(source.codeUnitAt(state.pos++));
    }
    if (state.ok) {
      final $v = _unwrap($1);
      state.ok = $v == 80;
      if (!state.ok) {
        $1 = null;
      }
    }
    if (!state.ok) {
      state.pos = $pos;
    }
    if (state.ok) {
      $list.add(_unwrap($1));
    } else {
      break;
    }
  }
  state.ok = true;
  $0 = _wrap($list);
  return $0;
}

List<int>? many0C32(State<String> state) {
  List<int>? $0;
  final $list = <int>[];
  while (true) {
    int? $1;
    $1 = char32(state);
    if (state.ok) {
      $list.add(_unwrap($1));
    } else {
      break;
    }
  }
  state.ok = true;
  $0 = _wrap($list);
  return $0;
}

int? many0CountC32(State<String> state) {
  int? $0;
  var $count = 0;
  while (true) {
    char32(state);
    if (state.ok) {
      $count++;
    } else {
      break;
    }
  }
  state.ok = true;
  $0 = _wrap($count);
  return $0;
}

List<int>? many1C32(State<String> state) {
  List<int>? $0;
  final $list = <int>[];
  while (true) {
    int? $1;
    $1 = char32(state);
    if (state.ok) {
      $list.add(_unwrap($1));
    } else {
      break;
    }
  }
  state.ok = $list.isNotEmpty;
  if (state.ok) {
    $0 = _wrap($list);
  }
  return $0;
}

int? many1CountC32(State<String> state) {
  int? $0;
  var $count = 0;
  while (true) {
    char32(state);
    if (state.ok) {
      $count++;
    } else {
      break;
    }
  }
  state.ok = $count != 0;
  if (state.ok) {
    $0 = _wrap($count);
  }
  return $0;
}

List<int>? manyMNC32_2_3(State<String> state) {
  List<int>? $0;
  final $pos = state.pos;
  final $list = <int>[];
  var $count = 0;
  while ($count < 3) {
    int? $1;
    $1 = char32(state);
    if (state.ok) {
      $list.add(_unwrap($1));
      $count++;
    } else {
      break;
    }
  }
  state.ok = $count >= 2;
  if (state.ok) {
    $0 = _wrap($list);
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
      $1 = _wrap('abc');
    } else {
      state.error = ErrExpected.tag(state.pos, const Tag('abc'));
    }
    if (state.ok) {
      $0 = _wrap(Tuple2($list, _unwrap($1)));
      break;
    } else {
      final $error = state.error;
      String? $2;
      state.ok =
          state.pos < source.length && source.codeUnitAt(state.pos) == 97;
      if (state.ok) {
        state.pos++;
        $2 = _wrap('a');
      } else {
        state.error = ErrExpected.tag(state.pos, const Tag('a'));
      }
      if (!state.ok) {
        final $error1 = state.error;
        state.ok =
            state.pos < source.length && source.codeUnitAt(state.pos) == 98;
        if (state.ok) {
          state.pos++;
          $2 = _wrap('b');
        } else {
          state.error = ErrExpected.tag(state.pos, const Tag('b'));
        }
        if (!state.ok) {
          state.error = ErrCombined(state.pos, [$error1, state.error]);
        }
      }
      if (state.ok) {
        $list.add(_unwrap($2));
      } else {
        state.error = ErrCombined(state.pos, [$error, state.error]);
        state.pos = $pos;
        break;
      }
    }
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
    $1 = _wrap(source.codeUnitAt(state.pos++));
  }
  if (state.ok) {
    final $v = _unwrap($1);
    state.ok = $v >= 48 && $v <= 57;
    if (!state.ok) {
      $1 = null;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  if (state.ok) {
    int? $2;
    final $pos1 = state.pos;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $2 = _wrap(source.codeUnitAt(state.pos++));
    }
    if (state.ok) {
      final $v1 = _unwrap($2);
      state.ok = $v1 >= 48 && $v1 <= 57;
      if (!state.ok) {
        $2 = null;
      }
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
    }
    if (state.ok) {
      int? $3;
      final $pos2 = state.pos;
      state.ok = state.pos < source.length;
      if (state.ok) {
        $3 = _wrap(source.codeUnitAt(state.pos++));
      }
      if (state.ok) {
        final $v2 = _unwrap($3);
        state.ok = $v2 >= 48 && $v2 <= 57;
        if (!state.ok) {
          $3 = null;
        }
      }
      if (!state.ok) {
        state.pos = $pos2;
        state.error = ErrUnexpected.charOrEof(state.pos, source);
      }
      if (state.ok) {
        int? $4;
        final $pos3 = state.pos;
        state.ok = state.pos < source.length;
        if (state.ok) {
          $4 = _wrap(source.codeUnitAt(state.pos++));
        }
        if (state.ok) {
          final $v3 = _unwrap($4);
          state.ok = $v3 >= 48 && $v3 <= 57;
          if (!state.ok) {
            $4 = null;
          }
        }
        if (!state.ok) {
          state.pos = $pos3;
          state.error = ErrUnexpected.charOrEof(state.pos, source);
        }
        if (state.ok) {
          final $v4 = _unwrap($1);
          final $v5 = _unwrap($2);
          final $v6 = _unwrap($3);
          final $v7 = _unwrap($4);
          $0 = _wrap(($v4 - 0x30) * 1000 +
              ($v5 - 0x30) * 100 +
              ($v6 - 0x30) * 10 +
              $v7 -
              0x30);
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
  final $pos = state.pos;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $1 = _wrap(source.readRune(state));
  }
  if (state.ok) {
    final $v = _unwrap($1);
    state.ok = $v == 119296;
    if (!state.ok) {
      $1 = null;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrExpected.char(state.pos, const Char(119296));
  }
  if (state.ok) {
    final $v1 = _unwrap($1);
    $0 = _wrap(String.fromCharCode($v1));
  }
  return $0;
}

int? noneOfC16(State<String> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $0 = _wrap(source.readRune(state));
  }
  if (state.ok) {
    final $v = _unwrap($0);
    state.ok = $v != 80;
    if (!state.ok) {
      $0 = null;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  return $0;
}

int? noneOfOfC16OrC32(State<String> state) {
  int? $0;
  final source = state.source;
  final $calculate = state.context.listOfC16AndC32 as List<int>;
  List<int>? $1;
  state.ok = true;
  $1 = _wrap($calculate);
  if (state.ok) {
    state.ok = state.pos < source.length;
    if (state.ok) {
      final $pos = state.pos;
      final $c = source.readRune(state);
      final $list = _unwrap($1);
      for (var i = 0; i < $list.length; i++) {
        final $ch = $list[i];
        if ($c == $ch) {
          state.pos = $pos;
          state.ok = false;
          state.error = ErrUnexpected.char(state.pos, Char($c));
          break;
        }
      }
      if (state.ok) {
        $0 = _wrap($c);
      }
    } else {
      state.error = ErrUnexpected.eof(state.pos);
    }
  }
  return $0;
}

int? noneOfC32(State<String> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $0 = _wrap(source.readRune(state));
  }
  if (state.ok) {
    final $v = _unwrap($0);
    state.ok = $v != 119296;
    if (!state.ok) {
      $0 = null;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  return $0;
}

void noneOfTagsAbcAbdDefDegXXY(State<String> state) {
  final source = state.source;
  state.ok = true;
  final $pos = state.pos;
  if (state.pos < source.length) {
    final $c = source.codeUnitAt($pos);
    switch ($c) {
      case 97:
        if (source.startsWith('abc', $pos)) {
          state.ok = false;
          state.error = ErrUnexpected.tag($pos, const Tag('abc'));
          break;
        }
        if (source.startsWith('abd', $pos)) {
          state.ok = false;
          state.error = ErrUnexpected.tag($pos, const Tag('abd'));
          break;
        }
        break;
      case 100:
        if (source.startsWith('def', $pos)) {
          state.ok = false;
          state.error = ErrUnexpected.tag($pos, const Tag('def'));
          break;
        }
        if (source.startsWith('deg', $pos)) {
          state.ok = false;
          state.error = ErrUnexpected.tag($pos, const Tag('deg'));
          break;
        }
        break;
      case 120:
        if (source.startsWith('xy', $pos)) {
          state.ok = false;
          state.error = ErrUnexpected.tag($pos, const Tag('xy'));
          break;
        }
        state.ok = false;
        state.error = ErrUnexpected.tag($pos, const Tag('x'));
        break;
    }
  }
}

void notC32OrC16(State<String> state) {
  final $pos = state.pos;
  char16(state);
  if (!state.ok) {
    char32(state);
  }
  state.ok = !state.ok;
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrUnknown(state.pos);
  }
}

int? oneOfC16(State<String> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $0 = _wrap(source.codeUnitAt(state.pos++));
  }
  if (state.ok) {
    final $v = _unwrap($0);
    state.ok = $v == 80;
    if (!state.ok) {
      $0 = null;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  return $0;
}

int? oneOfC32(State<String> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $0 = _wrap(source.readRune(state));
  }
  if (state.ok) {
    final $v = _unwrap($0);
    state.ok = $v == 119296;
    if (!state.ok) {
      $0 = null;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  return $0;
}

String? optAbc(State<String> state) {
  String? $0;
  final source = state.source;
  state.ok = state.pos < source.length &&
      source.codeUnitAt(state.pos) == 97 &&
      source.startsWith('abc', state.pos);
  if (state.ok) {
    state.pos += 3;
    $0 = _wrap('abc');
  }
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
      $0 = _wrap(Tuple2(_unwrap($1), _unwrap($2)));
    } else {
      state.pos = $pos;
    }
  }
  return $0;
}

int? peekC32(State<String> state) {
  int? $0;
  final $pos = state.pos;
  $0 = char32(state);
  if (state.ok) {
    state.pos = $pos;
  }
  return $0;
}

int? precededC16C32(State<String> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  char16(state);
  if (state.ok) {
    int? $2;
    final $pos1 = state.pos;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $2 = _wrap(source.readRune(state));
    }
    if (state.ok) {
      final $v = _unwrap($2);
      state.ok = $v == 119296;
      if (!state.ok) {
        $2 = null;
      }
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrExpected.char(state.pos, const Char(119296));
    }
    if (state.ok) {
      $0 = $2;
    } else {
      state.pos = $pos;
    }
  }
  return $0;
}

String? recognize3C32AbcC16(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  char32(state);
  if (state.ok) {
    tagAbc(state);
    if (state.ok) {
      char16(state);
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  if (state.ok) {
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

int? satisfyC16(State<String> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $0 = _wrap(source.codeUnitAt(state.pos++));
  }
  if (state.ok) {
    final $v = _unwrap($0);
    state.ok = $v == 80;
    if (!state.ok) {
      $0 = null;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  return $0;
}

int? satisfyC32(State<String> state) {
  int? $0;
  final source = state.source;
  final $pos = state.pos;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $0 = _wrap(source.readRune(state));
  }
  if (state.ok) {
    final $v = _unwrap($0);
    state.ok = $v == 119296;
    if (!state.ok) {
      $0 = null;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  return $0;
}

List<int>? separatedList0C32Abc(State<String> state) {
  List<int>? $0;
  final source = state.source;
  final $list = <int>[];
  var $pos = state.pos;
  while (true) {
    int? $1;
    final $pos1 = state.pos;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $1 = _wrap(source.readRune(state));
    }
    if (state.ok) {
      final $v = _unwrap($1);
      state.ok = $v == 119296;
      if (!state.ok) {
        $1 = null;
      }
    }
    if (!state.ok) {
      state.pos = $pos1;
    }
    if (state.ok) {
      $list.add(_unwrap($1));
    } else {
      state.pos = $pos;
      break;
    }
    $pos = state.pos;
    state.ok = state.pos < source.length &&
        source.codeUnitAt(state.pos) == 97 &&
        source.startsWith('abc', state.pos);
    if (state.ok) {
      state.pos += 3;
    }
    if (!state.ok) {
      break;
    }
  }
  state.ok = true;
  $0 = _wrap($list);
  return $0;
}

List<int>? separatedList1C32Abc(State<String> state) {
  List<int>? $0;
  final source = state.source;
  final $list = <int>[];
  var $pos = state.pos;
  while (true) {
    int? $1;
    final $pos1 = state.pos;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $1 = _wrap(source.readRune(state));
    }
    if (state.ok) {
      final $v = _unwrap($1);
      state.ok = $v == 119296;
      if (!state.ok) {
        $1 = null;
      }
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrExpected.char(state.pos, const Char(119296));
    }
    if (state.ok) {
      $list.add(_unwrap($1));
    } else {
      state.pos = $pos;
      break;
    }
    $pos = state.pos;
    state.ok = state.pos < source.length &&
        source.codeUnitAt(state.pos) == 97 &&
        source.startsWith('abc', state.pos);
    if (state.ok) {
      state.pos += 3;
    }
    if (!state.ok) {
      break;
    }
  }
  state.ok = $list.isNotEmpty;
  if (state.ok) {
    $0 = _wrap($list);
  }
  return $0;
}

Tuple2<int, int>? separatedPairC16AbcC32(State<String> state) {
  Tuple2<int, int>? $0;
  final source = state.source;
  final $pos = state.pos;
  int? $1;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $1 = _wrap(source.codeUnitAt(state.pos++));
  }
  if (state.ok) {
    final $v = _unwrap($1);
    state.ok = $v == 80;
    if (!state.ok) {
      $1 = null;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrExpected.char(state.pos, const Char(80));
  }
  if (state.ok) {
    state.ok = state.pos < source.length &&
        source.codeUnitAt(state.pos) == 97 &&
        source.startsWith('abc', state.pos);
    if (state.ok) {
      state.pos += 3;
    } else {
      state.error = ErrExpected.tag(state.pos, const Tag('abc'));
    }
    if (state.ok) {
      int? $3;
      final $pos1 = state.pos;
      state.ok = state.pos < source.length;
      if (state.ok) {
        $3 = _wrap(source.readRune(state));
      }
      if (state.ok) {
        final $v1 = _unwrap($3);
        state.ok = $v1 == 119296;
        if (!state.ok) {
          $3 = null;
        }
      }
      if (!state.ok) {
        state.pos = $pos1;
        state.error = ErrExpected.char(state.pos, const Char(119296));
      }
      if (state.ok) {
        $0 = _wrap(Tuple2(_unwrap($1), _unwrap($3)));
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
  var $ok = false;
  while (true) {
    final $pos = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.codeUnitAt(state.pos++));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v == 80;
    }
    if (!state.ok) {
      state.pos = $pos;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
    }
    if (state.ok) {
      $ok = true;
    } else {
      break;
    }
  }
  state.ok = $ok;
}

void skipWhile1C32(State<String> state) {
  final source = state.source;
  var $ok = false;
  while (true) {
    final $pos = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.readRune(state));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v == 119296;
    }
    if (!state.ok) {
      state.pos = $pos;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
    }
    if (state.ok) {
      $ok = true;
    } else {
      break;
    }
  }
  state.ok = $ok;
}

void skipWhileC16(State<String> state) {
  final source = state.source;
  while (true) {
    final $pos = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.codeUnitAt(state.pos++));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v == 80;
    }
    if (!state.ok) {
      state.pos = $pos;
    }
    if (!state.ok) {
      break;
    }
  }
  state.ok = true;
}

void skipWhileC32(State<String> state) {
  final source = state.source;
  while (true) {
    final $pos = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.readRune(state));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v == 119296;
    }
    if (!state.ok) {
      state.pos = $pos;
    }
    if (!state.ok) {
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
  final $list = [];
  var $str = '';
  while (state.pos < source.length) {
    final $start = state.pos;
    var $c = 0;
    while (state.pos < source.length) {
      final $pos1 = state.pos;
      $c = source.readRune(state);
      final $ok = $c >= 0x20 && $c != 0x22 && $c != 0x5c;
      if ($ok) {
        continue;
      }
      state.pos = $pos1;
      break;
    }
    $str = state.pos == $start ? '' : source.substring($start, state.pos);
    if ($str != '' && $list.isNotEmpty) {
      $list.add($str);
    }
    if ($c != 92) {
      break;
    }
    state.pos++;
    int? $1;
    int? $c1;
    state.ok = false;
    if (state.pos < source.length) {
      $c1 = source.codeUnitAt(state.pos);
      int? $v;
      switch ($c1) {
        case 110:
          $v = 10;
          break;
      }
      if ($v != null) {
        state.pos++;
        state.ok = true;
        $1 = _wrap($v);
      }
    }
    if (!state.ok) {
      state.error = $c1 == null
          ? ErrUnexpected.eof(state.pos)
          : ErrUnexpected.charAt(state.pos, source);
    }
    if (state.ok) {
      if ($list.isEmpty && $str != '') {
        $list.add($str);
      }
      $list.add(_unwrap($1));
    } else {
      state.pos = $pos;
      break;
    }
  }
  if (state.ok) {
    if ($list.isEmpty) {
      $0 = _wrap($str);
    } else {
      if ($list.length == 1) {
        final $c2 = $list[0] as int;
        $0 = _wrap(String.fromCharCode($c2));
      } else {
        final $buffer = StringBuffer();
        for (var i = 0; i < $list.length; i++) {
          final $obj = $list[i];
          if ($obj is int) {
            $buffer.writeCharCode($obj);
          } else {
            $buffer.write($obj);
          }
        }
        $0 = _wrap($buffer.toString());
      }
    }
  }
  return $0;
}

String? tagC16(State<String> state) {
  String? $0;
  final source = state.source;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 80;
  if (state.ok) {
    state.pos++;
    $0 = _wrap('P');
  } else {
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
    $0 = _wrap('P𝈀');
  } else {
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
    $0 = _wrap('𝈀');
  } else {
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
    $0 = _wrap('𝈀P');
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('𝈀P'));
  }
  return $0;
}

String? tagOfFoo(State<String> state) {
  String? $0;
  final source = state.source;
  final $calculate = state.context.foo as String;
  state.ok = true;
  $0 = _wrap($calculate);
  if (state.ok) {
    final $tag = _unwrap($0);
    state.ok = source.startsWith($tag, state.pos);
    if (state.ok) {
      state.pos += $tag.length;
    } else {
      $0 = null;
      state.error = ErrExpected.tag(state.pos, Tag($tag));
    }
  }
  return $0;
}

String? tagNoCaseAbc(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  int? $2;
  state.ok = true;
  $2 = _wrap(3);
  if (state.ok) {
    final $count = _unwrap($2);
    state.ok = state.pos + $count <= source.length;
    if (state.ok) {
      state.pos += $count;
    }
  }
  if (state.ok) {
    $0 = _wrap(source.slice($pos, state.pos));
  }
  if (state.ok) {
    final $v = _unwrap($0);
    state.ok = $v.toLowerCase() == 'abc';
    if (!state.ok) {
      $0 = null;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrExpected.tag(state.pos, const Tag('abc'));
  }
  return $0;
}

String? tagsAbcAbdDefDegXXY(State<String> state) {
  String? $0;
  final source = state.source;
  state.ok = false;
  final $pos = state.pos;
  if (state.pos < source.length) {
    final $c = source.codeUnitAt($pos);
    switch ($c) {
      case 97:
        if (source.startsWith('abc', $pos)) {
          state.pos += 3;
          state.ok = true;
          $0 = _wrap('abc');
          break;
        }
        if (source.startsWith('abd', $pos)) {
          state.pos += 3;
          state.ok = true;
          $0 = _wrap('abd');
          break;
        }
        break;
      case 100:
        if (source.startsWith('def', $pos)) {
          state.pos += 3;
          state.ok = true;
          $0 = _wrap('def');
          break;
        }
        if (source.startsWith('deg', $pos)) {
          state.pos += 3;
          state.ok = true;
          $0 = _wrap('deg');
          break;
        }
        break;
      case 120:
        if (source.startsWith('xy', $pos)) {
          state.pos += 2;
          state.ok = true;
          $0 = _wrap('xy');
          break;
        }
        state.pos++;
        state.ok = true;
        $0 = _wrap('x');
        break;
    }
  }
  if (!state.ok) {
    state.error = ErrCombined($pos, [
      ErrExpected.tag($pos, const Tag('abc')),
      ErrExpected.tag($pos, const Tag('abd')),
      ErrExpected.tag($pos, const Tag('def')),
      ErrExpected.tag($pos, const Tag('deg')),
      ErrExpected.tag($pos, const Tag('x')),
      ErrExpected.tag($pos, const Tag('xy'))
    ]);
  }
  return $0;
}

String? takeUntilAbc(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  int? $3;
  final $index = source.indexOf('abc', state.pos);
  state.ok = $index >= 0;
  if (state.ok) {
    $3 = _wrap($index);
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('abc'));
  }
  if (state.ok) {
    final $v = _unwrap($3);
    state.ok = $v <= source.length;
    if (state.ok) {
      state.pos = $v;
    } else {
      state.pos = $pos;
      state.error = ErrUnexpected.eof($pos);
    }
  }
  if (state.ok) {
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

String? takeUntil1Abc(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  int? $2;
  final $index = source.indexOf('abc', state.pos);
  state.ok = $index >= 0;
  if (state.ok) {
    $2 = _wrap($index);
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('abc'));
  }
  if (state.ok) {
    final $v = _unwrap($2);
    state.ok = $v > state.pos;
    if (!state.ok) {
      state.error = ErrMessage($pos, state.pos - $pos,
          'Expected at least one character before \'abc\'')
        ..failure = state.pos;
      state.pos = $pos;
    }
  }
  if (state.ok) {
    final $v1 = _unwrap($2);
    state.ok = $v1 <= source.length;
    if (state.ok) {
      state.pos = $v1;
    } else {
      state.pos = $pos;
      state.error = ErrUnexpected.eof($pos);
    }
  }
  if (state.ok) {
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

String? takeWhile1C16(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  var $ok = false;
  while (true) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.codeUnitAt(state.pos++));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v == 80;
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
    }
    if (state.ok) {
      $ok = true;
    } else {
      break;
    }
  }
  state.ok = $ok;
  if (state.ok) {
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

String? takeWhile1C32(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  var $ok = false;
  while (true) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.readRune(state));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v == 119296;
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
    }
    if (state.ok) {
      $ok = true;
    } else {
      break;
    }
  }
  state.ok = $ok;
  if (state.ok) {
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

String? takeWhileC16(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.codeUnitAt(state.pos++));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v == 80;
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
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

String? takeWhileC32(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.readRune(state));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v == 119296;
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
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

String? takeWhileMN_2_4C16(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  var $count = 0;
  while ($count < 4) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.codeUnitAt(state.pos++));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v == 80;
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
    }
    if (state.ok) {
      $count++;
    } else {
      break;
    }
  }
  state.ok = $count >= 2;
  if (!state.ok) {
    state.pos = $pos;
  }
  if (state.ok) {
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

String? takeWhileMN_2_4C32(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  var $count = 0;
  while ($count < 4) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.readRune(state));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v == 119296;
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
    }
    if (state.ok) {
      $count++;
    } else {
      break;
    }
  }
  state.ok = $count >= 2;
  if (!state.ok) {
    state.pos = $pos;
  }
  if (state.ok) {
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

int? terminated(State<String> state) {
  int? $0;
  final $pos = state.pos;
  int? $1;
  $1 = char16(state);
  if (state.ok) {
    char32(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = $pos;
    }
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
      $0 = _wrap(Tuple2(_unwrap($1), _unwrap($2)));
    } else {
      state.pos = $pos;
    }
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
      final $pos1 = state.pos;
      state.ok = state.pos < source.length;
      if (state.ok) {
        $3 = _wrap(source.codeUnitAt(state.pos++));
      }
      if (state.ok) {
        final $v = _unwrap($3);
        state.ok = $v == 80;
        if (!state.ok) {
          $3 = null;
        }
      }
      if (!state.ok) {
        state.pos = $pos1;
        state.error = ErrExpected.char(state.pos, const Char(80));
      }
      if (state.ok) {
        $0 = _wrap(Tuple3(_unwrap($1), _unwrap($2), _unwrap($3)));
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
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('abc'));
  }
  if (state.ok) {
    $0 = _wrap(true);
  }
  return $0;
}

bool? valueTrue(State<dynamic> state) {
  bool? $0;
  state.ok = true;
  $0 = _wrap(true);
  return $0;
}

String? transformersCharClassIsDigit(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.codeUnitAt(state.pos++));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v >= 48 && $v <= 57;
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
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

String? transformersClosureIsDigit(State<String> state) {
  String? $0;
  final source = state.source;
  final $predicate = (int x) => x >= 0x30 && x <= 0x39;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.readRune(state));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $predicate($v);
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
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

String? transformersExprIsDigit(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.readRune(state));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $v >= 0x30 && $v <= 0x39;
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
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

String? transformersFuncExprIsDigit(State<String> state) {
  String? $0;
  final source = state.source;
  bool $predicate(int x) => x >= 0x30 && x <= 0x39;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.readRune(state));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $predicate($v);
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
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

String? transformersFuncIsDigit(State<String> state) {
  String? $0;
  final source = state.source;
  bool $predicate(int x) {
    return x >= 0x30 && x <= 0x39;
  }

  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.readRune(state));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok = $predicate($v);
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
    $0 = _wrap(source.slice($pos, state.pos));
  }
  return $0;
}

String? transformersNotCharClassIsDigit(State<String> state) {
  String? $0;
  final source = state.source;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = _wrap(source.readRune(state));
    }
    if (state.ok) {
      final $v = _unwrap($3);
      state.ok =
          $v > 1114111 || !($v >= 0 && $v <= 47 || $v >= 58 && $v <= 1114111);
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
    $0 = _wrap(source.slice($pos, state.pos));
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
  List<int>? $1;
  state.ok = true;
  $1 = _wrap($calculate);
  if (state.ok) {
    state.ok = state.pos < source.length;
    if (state.ok) {
      final $pos = state.pos;
      final $c = source.readRune(state);
      final $list = _unwrap($1);
      for (var i = 0; i < $list.length; i++) {
        final $ch = $list[i];
        if ($c == $ch) {
          state.pos = $pos;
          state.ok = false;
          state.error = ErrUnexpected.char(state.pos, Char($c));
          break;
        }
      }
      if (state.ok) {
        $0 = _wrap($c);
      }
    } else {
      state.error = ErrUnexpected.eof(state.pos);
    }
  }
  return $0;
}

@pragma('vm:prefer-inline')
T _unwrap<T>(T? value) => value!;

@pragma('vm:prefer-inline')
T? _wrap<T>(T? value) => value;

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
