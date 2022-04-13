// ignore_for_file: unnecessary_cast

import 'package:tuple/tuple.dart';

String? alpha0(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.codeUnitAt(state.pos++) as int?;
      $c = $3!;
      state.ok = $c <= 122 && ($c >= 65 && $c <= 90 || $c >= 97 && $c <= 122);
    }
    if (!state.ok) {
      state.pos = $pos1;
      break;
    }
  }
  state.ok = true;
  $0 = state.source.slice($pos, state.pos) as String?;
  return $0;
}

String? alpha1(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  var $ok = false;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.codeUnitAt(state.pos++) as int?;
      $c = $3!;
      state.ok = $c <= 122 && ($c >= 65 && $c <= 90 || $c >= 97 && $c <= 122);
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
      break;
    } else {
      $ok = true;
    }
  }
  state.ok = $ok;
  if (state.ok) {
    $0 = state.source.slice($pos, state.pos) as String?;
  }
  return $0;
}

String? alphanumeric0(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.codeUnitAt(state.pos++) as int?;
      $c = $3!;
      state.ok = $c <= 122 &&
          ($c >= 48 && $c <= 57 ||
              $c >= 65 && $c <= 90 ||
              $c >= 97 && $c <= 122);
    }
    if (!state.ok) {
      state.pos = $pos1;
      break;
    }
  }
  state.ok = true;
  $0 = state.source.slice($pos, state.pos) as String?;
  return $0;
}

String? alphanumeric1(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  var $ok = false;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.codeUnitAt(state.pos++) as int?;
      $c = $3!;
      state.ok = $c <= 122 &&
          ($c >= 48 && $c <= 57 ||
              $c >= 65 && $c <= 90 ||
              $c >= 97 && $c <= 122);
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
      break;
    } else {
      $ok = true;
    }
  }
  state.ok = $ok;
  if (state.ok) {
    $0 = state.source.slice($pos, state.pos) as String?;
  }
  return $0;
}

int? char16(State<String> state) {
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  int? $1;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $1 = source.codeUnitAt(state.pos++) as int?;
    state.ok = ($1 as int?)! == 80;
    if (state.ok) {
      $0 = $1;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrExpected.char(state.pos, const Char(80));
  }
  return $0;
}

int? altC16OrC32(State<String> state) {
  final source = state.source;
  int? $0;
  $0 = char16(state);
  if (!state.ok) {
    final $error = state.error;
    final $pos = state.pos;
    int? $1;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $1 = source.readRune(state) as int?;
      state.ok = ($1 as int?)! == 119296;
      if (state.ok) {
        $0 = $1;
      }
    }
    if (!state.ok) {
      state.pos = $pos;
      state.error = ErrExpected.char(state.pos, const Char(119296));
      state.error = ErrCombined(state.pos, [$error, state.error]);
    }
  }
  return $0;
}

int? anyChar(State<String> state) {
  final source = state.source;
  int? $0;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $0 = source.readRune(state) as int?;
  } else {
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
}

int? char32(State<String> state) {
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  int? $1;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $1 = source.readRune(state) as int?;
    state.ok = ($1 as int?)! == 119296;
    if (state.ok) {
      $0 = $1;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrExpected.char(state.pos, const Char(119296));
  }
  return $0;
}

String? tagAbc(State<String> state) {
  final source = state.source;
  String? $0;
  state.ok = state.pos < source.length &&
      source.codeUnitAt(state.pos) == 97 &&
      source.startsWith('abc', state.pos);
  if (state.ok) {
    state.pos += 3;
    $0 = 'abc' as String?;
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('abc'));
  }
  return $0;
}

Tuple2<String, List<String>>? consumedSeparatedAbcC32(State<String> state) {
  Tuple2<String, List<String>>? $0;
  final $pos = state.pos;
  List<String>? $1;
  var $pos1 = state.pos;
  final $list = <String>[];
  while (true) {
    String? $2;
    $2 = tagAbc(state);
    if (state.ok) {
      $list.add($2!);
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
    $1 = $list as List<String>?;
    final $v = state.source.slice($pos, state.pos);
    $0 = Tuple2($v, ($1 as List<String>?)!) as Tuple2<String, List<String>>?;
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
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.codeUnitAt(state.pos++) as int?;
      $c = $3!;
      state.ok = $c >= 48 && $c <= 57;
    }
    if (!state.ok) {
      state.pos = $pos1;
      break;
    }
  }
  state.ok = true;
  $0 = state.source.slice($pos, state.pos) as String?;
  return $0;
}

String? digit1(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  var $ok = false;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.codeUnitAt(state.pos++) as int?;
      $c = $3!;
      state.ok = $c >= 48 && $c <= 57;
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
      break;
    } else {
      $ok = true;
    }
  }
  state.ok = $ok;
  if (state.ok) {
    $0 = state.source.slice($pos, state.pos) as String?;
  }
  return $0;
}

void eof(State<String> state) {
  state.ok = state.pos >= state.source.length;
  if (!state.ok) {
    state.error = ErrExpected.eof(state.pos);
  }
}

int? escapeSequence16(State<String> state) {
  final source = state.source;
  int? $0;
  int? $c;
  state.ok = state.pos < source.length;
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
      $0 = $v as int?;
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
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  int? $c;
  state.ok = state.pos < source.length;
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
      $0 = $v as int?;
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
  final source = state.source;
  dynamic $0;
  var $acc = 0;
  while (true) {
    int? $1;
    final $pos = state.pos;
    int? $c;
    int? $2;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $2 = source.codeUnitAt(state.pos++) as int?;
      $c = ($2 as int?)!;
      state.ok = $c >= 48 && $c <= 57;
      if (state.ok) {
        $1 = $2;
      }
    }
    if (!state.ok) {
      state.pos = $pos;
      break;
    } else {
      final $v = ($1 as int?)!;
      $acc = $acc * 10 + $v - 0x30;
    }
  }
  state.ok = true;
  $0 = $acc as dynamic;
  return $0;
}

String? hexDigit0(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.codeUnitAt(state.pos++) as int?;
      $c = $3!;
      state.ok = $c <= 102 &&
          ($c >= 48 && $c <= 57 ||
              $c >= 65 && $c <= 70 ||
              $c >= 97 && $c <= 102);
    }
    if (!state.ok) {
      state.pos = $pos1;
      break;
    }
  }
  state.ok = true;
  $0 = state.source.slice($pos, state.pos) as String?;
  return $0;
}

String? hexDigit1(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  var $ok = false;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.codeUnitAt(state.pos++) as int?;
      $c = $3!;
      state.ok = $c <= 102 &&
          ($c >= 48 && $c <= 57 ||
              $c >= 65 && $c <= 70 ||
              $c >= 97 && $c <= 102);
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
      break;
    } else {
      $ok = true;
    }
  }
  state.ok = $ok;
  if (state.ok) {
    $0 = state.source.slice($pos, state.pos) as String?;
  }
  return $0;
}

List<int>? many0C16(State<String> state) {
  final source = state.source;
  List<int>? $0;
  final $list = <int>[];
  while (true) {
    int? $1;
    final $pos = state.pos;
    int? $2;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $2 = source.codeUnitAt(state.pos++) as int?;
      state.ok = ($2 as int?)! == 80;
      if (state.ok) {
        $1 = $2;
      }
    }
    if (!state.ok) {
      state.pos = $pos;
      break;
    } else {
      $list.add($1!);
    }
  }
  state.ok = true;
  $0 = $list as List<int>?;
  return $0;
}

List<int>? many0C32(State<String> state) {
  List<int>? $0;
  final $list = <int>[];
  while (true) {
    int? $1;
    $1 = char32(state);
    if (state.ok) {
      $list.add($1!);
    } else {
      break;
    }
  }
  state.ok = true;
  $0 = $list as List<int>?;
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
  $0 = $count as int?;
  return $0;
}

List<int>? many1C32(State<String> state) {
  List<int>? $0;
  final $list = <int>[];
  while (true) {
    int? $1;
    $1 = char32(state);
    if (state.ok) {
      $list.add($1!);
    } else {
      break;
    }
  }
  state.ok = $list.isNotEmpty;
  if (state.ok) {
    $0 = $list as List<int>?;
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
    $0 = $count as int?;
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
      $list.add($1!);
      $count++;
    } else {
      break;
    }
  }
  state.ok = $count >= 2;
  if (state.ok) {
    $0 = $list as List<int>?;
  } else {
    state.pos = $pos;
  }
  return $0;
}

Tuple2<List<String>, String>? manyTillAOrBTillAbc(State<String> state) {
  final source = state.source;
  Tuple2<List<String>, String>? $0;
  final $pos = state.pos;
  final $list = <String>[];
  while (true) {
    String? $1;
    state.ok = state.pos < source.length &&
        source.codeUnitAt(state.pos) == 97 &&
        source.startsWith('abc', state.pos);
    if (state.ok) {
      state.pos += 3;
      $1 = 'abc' as String?;
      $0 = Tuple2($list, ($1 as String?)!) as Tuple2<List<String>, String>?;
      break;
    } else {
      state.error = ErrExpected.tag(state.pos, const Tag('abc'));
      final $error = state.error;
      String? $2;
      state.ok =
          state.pos < source.length && source.codeUnitAt(state.pos) == 97;
      if (state.ok) {
        state.pos += 1;
        $2 = 'a' as String?;
      } else {
        state.error = ErrExpected.tag(state.pos, const Tag('a'));
        final $error1 = state.error;
        state.ok =
            state.pos < source.length && source.codeUnitAt(state.pos) == 98;
        if (state.ok) {
          state.pos += 1;
          $2 = 'b' as String?;
        } else {
          state.error = ErrExpected.tag(state.pos, const Tag('b'));
          state.error = ErrCombined(state.pos, [$error1, state.error]);
          state.error = ErrCombined(state.pos, [$error, state.error]);
          state.pos = $pos;
          break;
        }
      }
      if (state.ok) {
        $list.add($2!);
      }
    }
  }
  return $0;
}

dynamic map4Digits(State<String> state) {
  final source = state.source;
  dynamic $0;
  final $pos = state.pos;
  int? $1;
  final $pos1 = state.pos;
  int? $c;
  int? $2;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $2 = source.codeUnitAt(state.pos++) as int?;
    $c = ($2 as int?)!;
    state.ok = $c >= 48 && $c <= 57;
    if (state.ok) {
      $1 = $2;
    }
  }
  if (!state.ok) {
    state.pos = $pos1;
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  } else {
    int? $3;
    final $pos2 = state.pos;
    int? $c1;
    int? $4;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $4 = source.codeUnitAt(state.pos++) as int?;
      $c1 = ($4 as int?)!;
      state.ok = $c1 >= 48 && $c1 <= 57;
      if (state.ok) {
        $3 = $4;
      }
    }
    if (!state.ok) {
      state.pos = $pos2;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
    } else {
      int? $5;
      final $pos3 = state.pos;
      int? $c2;
      int? $6;
      state.ok = state.pos < source.length;
      if (state.ok) {
        $6 = source.codeUnitAt(state.pos++) as int?;
        $c2 = ($6 as int?)!;
        state.ok = $c2 >= 48 && $c2 <= 57;
        if (state.ok) {
          $5 = $6;
        }
      }
      if (!state.ok) {
        state.pos = $pos3;
        state.error = ErrUnexpected.charOrEof(state.pos, source);
      } else {
        int? $7;
        final $pos4 = state.pos;
        int? $c3;
        int? $8;
        state.ok = state.pos < source.length;
        if (state.ok) {
          $8 = source.codeUnitAt(state.pos++) as int?;
          $c3 = ($8 as int?)!;
          state.ok = $c3 >= 48 && $c3 <= 57;
          if (state.ok) {
            $7 = $8;
          }
        }
        if (!state.ok) {
          state.pos = $pos4;
          state.error = ErrUnexpected.charOrEof(state.pos, source);
        } else {
          final $v = ($1 as int?)!;
          final $v1 = ($3 as int?)!;
          final $v2 = ($5 as int?)!;
          final $v3 = ($7 as int?)!;
          $0 = ($v - 0x30) * 1000 +
              ($v1 - 0x30) * 100 +
              ($v2 - 0x30) * 10 +
              $v3 -
              0x30 as dynamic;
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
  final source = state.source;
  String? $0;
  int? $1;
  final $pos = state.pos;
  int? $2;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $2 = source.readRune(state) as int?;
    state.ok = ($2 as int?)! == 119296;
    if (state.ok) {
      $1 = $2;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrExpected.char(state.pos, const Char(119296));
  } else {
    final $v = ($1 as int?)!;
    $0 = String.fromCharCode($v) as String?;
  }
  return $0;
}

int? noneOfC16(State<String> state) {
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  int? $c;
  int? $1;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $1 = source.readRune(state) as int?;
    $c = ($1 as int?)!;
    state.ok = $c != 80;
    if (state.ok) {
      $0 = $1;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrUnexpected.charOrEof(state.pos, source, $c);
  }
  return $0;
}

int? noneOfOfC16OrC32(State<String> state) {
  final source = state.source;
  final $calculate = state.context.listOfC16AndC32 as List<int>;
  int? $0;
  List<int>? $1;
  final $v = $calculate;
  state.ok = true;
  $1 = $v as List<int>?;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final pos = state.pos;
    final $c = source.readRune(state);
    final list = ($1 as List<int>?)!;
    for (var i = 0; i < list.length; i++) {
      final ch = list[i];
      if ($c == ch) {
        state.pos = pos;
        state.ok = false;
        state.error = ErrUnexpected.char(state.pos, Char($c));
        break;
      }
    }
    if (state.ok) {
      $0 = $c as int?;
    }
  } else {
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
}

int? noneOfC32(State<String> state) {
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  int? $c;
  int? $1;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $1 = source.readRune(state) as int?;
    $c = ($1 as int?)!;
    state.ok = $c != 119296;
    if (state.ok) {
      $0 = $1;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrUnexpected.charOrEof(state.pos, source, $c);
  }
  return $0;
}

void noneOfTagsAbcAbdDefDegXXY(State<String> state) {
  final source = state.source;
  state.ok = true;
  final $pos = state.pos;
  if (state.pos < source.length) {
    final c = source.codeUnitAt($pos);
    switch (c) {
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
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  int? $c;
  int? $1;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $1 = source.codeUnitAt(state.pos++) as int?;
    $c = ($1 as int?)!;
    state.ok = $c == 80;
    if (state.ok) {
      $0 = $1;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  return $0;
}

int? oneOfC32(State<String> state) {
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  int? $c;
  int? $1;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $1 = source.readRune(state) as int?;
    $c = ($1 as int?)!;
    state.ok = $c == 119296;
    if (state.ok) {
      $0 = $1;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrUnexpected.charOrEof(state.pos, source, $c);
  }
  return $0;
}

String? optAbc(State<String> state) {
  final source = state.source;
  String? $0;
  state.ok = state.pos < source.length &&
      source.codeUnitAt(state.pos) == 97 &&
      source.startsWith('abc', state.pos);
  if (state.ok) {
    state.pos += 3;
    $0 = 'abc' as String?;
  } else {
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
      $0 = Tuple2(($1 as int?)!, ($2 as int?)!) as Tuple2<int, int>?;
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
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  char16(state);
  if (state.ok) {
    int? $2;
    final $pos1 = state.pos;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.readRune(state) as int?;
      state.ok = ($3 as int?)! == 119296;
      if (state.ok) {
        $2 = $3;
      }
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrExpected.char(state.pos, const Char(119296));
      state.pos = $pos;
    } else {
      $0 = $2;
    }
  }
  return $0;
}

String? recognize3C32AbcC16(State<String> state) {
  String? $0;
  final $pos = state.pos;
  final $pos1 = state.pos;
  char32(state);
  if (state.ok) {
    tagAbc(state);
    if (state.ok) {
      char16(state);
      if (state.ok) {
        $0 = state.source.slice($pos, state.pos) as String?;
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos1;
  }
  return $0;
}

int? satisfyC16(State<String> state) {
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  int? $c;
  int? $1;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $1 = source.codeUnitAt(state.pos++) as int?;
    $c = ($1 as int?)!;
    state.ok = $c == 80;
    if (state.ok) {
      $0 = $1;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  return $0;
}

int? satisfyC32(State<String> state) {
  final source = state.source;
  int? $0;
  final $pos = state.pos;
  int? $c;
  int? $1;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $1 = source.readRune(state) as int?;
    $c = ($1 as int?)!;
    state.ok = $c == 119296;
    if (state.ok) {
      $0 = $1;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.error = ErrUnexpected.charOrEof(state.pos, source, $c);
  }
  return $0;
}

List<int>? separatedList0C32Abc(State<String> state) {
  final source = state.source;
  List<int>? $0;
  var $pos = state.pos;
  final $list = <int>[];
  while (true) {
    int? $1;
    final $pos1 = state.pos;
    int? $2;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $2 = source.readRune(state) as int?;
      state.ok = ($2 as int?)! == 119296;
      if (state.ok) {
        $1 = $2;
      }
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.pos = $pos;
      break;
    } else {
      $list.add($1!);
    }
    $pos = state.pos;
    state.ok = state.pos < source.length &&
        source.codeUnitAt(state.pos) == 97 &&
        source.startsWith('abc', state.pos);
    if (state.ok) {
      state.pos += 3;
    } else {
      break;
    }
  }
  state.ok = true;
  $0 = $list as List<int>?;
  return $0;
}

List<int>? separatedList1C32Abc(State<String> state) {
  final source = state.source;
  List<int>? $0;
  var $pos = state.pos;
  final $list = <int>[];
  while (true) {
    int? $1;
    final $pos1 = state.pos;
    int? $2;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $2 = source.readRune(state) as int?;
      state.ok = ($2 as int?)! == 119296;
      if (state.ok) {
        $1 = $2;
      }
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrExpected.char(state.pos, const Char(119296));
      state.pos = $pos;
      break;
    } else {
      $list.add($1!);
    }
    $pos = state.pos;
    state.ok = state.pos < source.length &&
        source.codeUnitAt(state.pos) == 97 &&
        source.startsWith('abc', state.pos);
    if (state.ok) {
      state.pos += 3;
    } else {
      break;
    }
  }
  state.ok = $list.isNotEmpty;
  if (state.ok) {
    $0 = $list as List<int>?;
  }
  return $0;
}

Tuple2<int, int>? separatedPairC16AbcC32(State<String> state) {
  final source = state.source;
  Tuple2<int, int>? $0;
  final $pos = state.pos;
  int? $1;
  final $pos1 = state.pos;
  int? $2;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $2 = source.codeUnitAt(state.pos++) as int?;
    state.ok = ($2 as int?)! == 80;
    if (state.ok) {
      $1 = $2;
    }
  }
  if (!state.ok) {
    state.pos = $pos1;
    state.error = ErrExpected.char(state.pos, const Char(80));
  } else {
    state.ok = state.pos < source.length &&
        source.codeUnitAt(state.pos) == 97 &&
        source.startsWith('abc', state.pos);
    if (state.ok) {
      state.pos += 3;
      int? $4;
      final $pos2 = state.pos;
      int? $5;
      state.ok = state.pos < source.length;
      if (state.ok) {
        $5 = source.readRune(state) as int?;
        state.ok = ($5 as int?)! == 119296;
        if (state.ok) {
          $4 = $5;
        }
      }
      if (!state.ok) {
        state.pos = $pos2;
        state.error = ErrExpected.char(state.pos, const Char(119296));
      } else {
        $0 = Tuple2(($1 as int?)!, ($4 as int?)!) as Tuple2<int, int>?;
      }
    } else {
      state.error = ErrExpected.tag(state.pos, const Tag('abc'));
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

dynamic skipABC(State<String> state) {
  final source = state.source;
  dynamic $0;
  state.ok = state.pos + 3 <= source.length;
  if (state.ok) {
    state.pos += 3;
    $0 = 'ABC' as dynamic;
  } else {
    state.error = ErrUnexpected.eof(source.length);
  }
  return $0;
}

void skipWhile1C16(State<String> state) {
  final source = state.source;
  var $ok = false;
  while (true) {
    final $pos = state.pos;
    int? $c;
    int? $2;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $2 = source.codeUnitAt(state.pos++) as int?;
      $c = $2!;
      state.ok = $c == 80;
    }
    if (!state.ok) {
      state.pos = $pos;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
      break;
    } else {
      $ok = true;
    }
  }
  state.ok = $ok;
}

void skipWhile1C32(State<String> state) {
  final source = state.source;
  var $ok = false;
  while (true) {
    final $pos = state.pos;
    int? $c;
    int? $2;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $2 = source.readRune(state) as int?;
      $c = $2!;
      state.ok = $c == 119296;
    }
    if (!state.ok) {
      state.pos = $pos;
      state.error = ErrUnexpected.charOrEof(state.pos, source, $c);
      break;
    } else {
      $ok = true;
    }
  }
  state.ok = $ok;
}

void skipWhileC16(State<String> state) {
  final source = state.source;
  while (true) {
    final $pos = state.pos;
    int? $c;
    int? $2;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $2 = source.codeUnitAt(state.pos++) as int?;
      $c = $2!;
      state.ok = $c == 80;
    }
    if (!state.ok) {
      state.pos = $pos;
      break;
    }
  }
  state.ok = true;
}

void skipWhileC32(State<String> state) {
  final source = state.source;
  while (true) {
    final $pos = state.pos;
    int? $c;
    int? $2;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $2 = source.readRune(state) as int?;
      $c = $2!;
      state.ok = $c == 119296;
    }
    if (!state.ok) {
      state.pos = $pos;
      break;
    }
  }
  state.ok = true;
}

String? stringValue(State<String> state) {
  final source = state.source;
  String? $0;
  state.ok = true;
  final $pos = state.pos;
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
    int? $1;
    int? $c1;
    state.ok = state.pos < source.length;
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
        $1 = $v as int?;
      }
    }
    if (!state.ok) {
      state.error = $c1 == null
          ? ErrUnexpected.eof(state.pos)
          : ErrUnexpected.charAt(state.pos, source);
      state.pos = $pos;
      break;
    }
    if ($list.isEmpty && $str != '') {
      $list.add($str);
    }
    $list.add(($1 as int?)!);
  }
  if (state.ok) {
    if ($list.isEmpty) {
      $0 = $str as String?;
    } else {
      if ($list.length == 1) {
        final c = $list[0] as int;
        $0 = String.fromCharCode(c) as String?;
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
        $0 = buffer.toString() as String?;
      }
    }
  }
  return $0;
}

String? tagC16(State<String> state) {
  final source = state.source;
  String? $0;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 80;
  if (state.ok) {
    state.pos += 1;
    $0 = 'P' as String?;
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('P'));
  }
  return $0;
}

String? tagC16C32(State<String> state) {
  final source = state.source;
  String? $0;
  state.ok = state.pos < source.length &&
      source.codeUnitAt(state.pos) == 80 &&
      source.startsWith('P𝈀', state.pos);
  if (state.ok) {
    state.pos += 3;
    $0 = 'P𝈀' as String?;
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('P𝈀'));
  }
  return $0;
}

String? tagC32(State<String> state) {
  final source = state.source;
  String? $0;
  state.ok = state.pos + 1 < source.length &&
      source.codeUnitAt(state.pos) == 55348 &&
      source.codeUnitAt(state.pos + 1) == 56832;
  if (state.ok) {
    state.pos += 2;
    $0 = '𝈀' as String?;
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('𝈀'));
  }
  return $0;
}

String? tagC32C16(State<String> state) {
  final source = state.source;
  String? $0;
  state.ok = state.pos < source.length &&
      source.codeUnitAt(state.pos) == 55348 &&
      source.startsWith('𝈀P', state.pos);
  if (state.ok) {
    state.pos += 3;
    $0 = '𝈀P' as String?;
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('𝈀P'));
  }
  return $0;
}

String? tagOfFoo(State<String> state) {
  final source = state.source;
  final $calculate = state.context.foo as String;
  String? $0;
  String? $1;
  final $v = $calculate;
  state.ok = true;
  $1 = $v as String?;
  final tag = ($1 as String?)!;
  state.ok = source.startsWith(tag, state.pos);
  if (state.ok) {
    state.pos += tag.length;
    $0 = tag as String?;
  } else {
    state.error = ErrExpected.tag(state.pos, Tag(tag));
  }
  return $0;
}

String? tagNoCaseAbc(State<String> state) {
  final source = state.source;
  String? $0;
  state.ok = false;
  if (state.pos + 3 <= source.length) {
    final v1 = source.substring(state.pos, state.pos + 3);
    final v2 = v1.toLowerCase();
    if (v2 == 'abc') {
      state.pos += 3;
      state.ok = true;
      $0 = v1 as String?;
    }
  }
  if (!state.ok) {
    state.error = ErrExpected.tag(state.pos, const Tag('abc'));
  }
  return $0;
}

String? tagsAbcAbdDefDegXXY(State<String> state) {
  final source = state.source;
  String? $0;
  state.ok = false;
  final $pos = state.pos;
  if (state.pos < source.length) {
    final c = source.codeUnitAt($pos);
    switch (c) {
      case 97:
        if (source.startsWith('abc', $pos)) {
          state.pos += 3;
          state.ok = true;
          $0 = 'abc' as String?;
          break;
        }
        if (source.startsWith('abd', $pos)) {
          state.pos += 3;
          state.ok = true;
          $0 = 'abd' as String?;
          break;
        }
        break;
      case 100:
        if (source.startsWith('def', $pos)) {
          state.pos += 3;
          state.ok = true;
          $0 = 'def' as String?;
          break;
        }
        if (source.startsWith('deg', $pos)) {
          state.pos += 3;
          state.ok = true;
          $0 = 'deg' as String?;
          break;
        }
        break;
      case 120:
        if (source.startsWith('xy', $pos)) {
          state.pos += 2;
          state.ok = true;
          $0 = 'xy' as String?;
          break;
        }
        state.pos++;
        state.ok = true;
        $0 = 'x' as String?;
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
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  int? $2;
  final $index = source.indexOf('abc', state.pos);
  state.ok = $index >= 0;
  if (state.ok) {
    $2 = $index as int?;
    final $pos1 = ($2 as int?)!;
    state.ok = $pos1 <= source.length;
    if (state.ok) {
      state.pos = $pos1;
      $0 = state.source.slice($pos, state.pos) as String?;
    } else {
      state.error = ErrUnexpected.eof($pos1);
    }
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('abc'));
  }
  return $0;
}

String? takeUntil1Abc(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  int? $2;
  final $pos2 = state.pos;
  final $index = source.indexOf('abc', state.pos);
  state.ok = $index >= 0;
  if (state.ok) {
    $2 = $index as int?;
    final $v = ($2 as int?)!;
    state.ok = $v > state.pos;
    if (!state.ok) {
      state.error = ErrMessage($pos2, state.pos - $pos2,
          'Expected at least one character before \'abc\'');
      state.error.failure = state.pos;
    } else {
      final $pos1 = ($2 as int?)!;
      state.ok = $pos1 <= source.length;
      if (state.ok) {
        state.pos = $pos1;
        $0 = state.source.slice($pos, state.pos) as String?;
      } else {
        state.error = ErrUnexpected.eof($pos1);
      }
    }
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('abc'));
  }
  return $0;
}

String? takeWhile1C16(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  var $ok = false;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.codeUnitAt(state.pos++) as int?;
      $c = $3!;
      state.ok = $c == 80;
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
      break;
    } else {
      $ok = true;
    }
  }
  state.ok = $ok;
  if (state.ok) {
    $0 = state.source.slice($pos, state.pos) as String?;
  }
  return $0;
}

String? takeWhile1C32(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  var $ok = false;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.readRune(state) as int?;
      $c = $3!;
      state.ok = $c == 119296;
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.error = ErrUnexpected.charOrEof(state.pos, source, $c);
      break;
    } else {
      $ok = true;
    }
  }
  state.ok = $ok;
  if (state.ok) {
    $0 = state.source.slice($pos, state.pos) as String?;
  }
  return $0;
}

String? takeWhileC16(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.codeUnitAt(state.pos++) as int?;
      $c = $3!;
      state.ok = $c == 80;
    }
    if (!state.ok) {
      state.pos = $pos1;
      break;
    }
  }
  state.ok = true;
  $0 = state.source.slice($pos, state.pos) as String?;
  return $0;
}

String? takeWhileC32(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.readRune(state) as int?;
      $c = $3!;
      state.ok = $c == 119296;
    }
    if (!state.ok) {
      state.pos = $pos1;
      break;
    }
  }
  state.ok = true;
  $0 = state.source.slice($pos, state.pos) as String?;
  return $0;
}

String? takeWhileMN_2_4C16(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  final $pos1 = state.pos;
  var $count = 0;
  while ($count < 4) {
    final $pos2 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.codeUnitAt(state.pos++) as int?;
      $c = $3!;
      state.ok = $c == 80;
    }
    if (!state.ok) {
      state.pos = $pos2;
      state.error = ErrUnexpected.charOrEof(state.pos, source);
      break;
    } else {
      $count++;
    }
  }
  state.ok = $count >= 2;
  if (state.ok) {
    $0 = state.source.slice($pos, state.pos) as String?;
  } else {
    state.pos = $pos1;
  }
  return $0;
}

String? takeWhileMN_2_4C32(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  final $pos1 = state.pos;
  var $count = 0;
  while ($count < 4) {
    final $pos2 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.readRune(state) as int?;
      $c = $3!;
      state.ok = $c == 119296;
    }
    if (!state.ok) {
      state.pos = $pos2;
      state.error = ErrUnexpected.charOrEof(state.pos, source, $c);
      break;
    } else {
      $count++;
    }
  }
  state.ok = $count >= 2;
  if (state.ok) {
    $0 = state.source.slice($pos, state.pos) as String?;
  } else {
    state.pos = $pos1;
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
      $0 = Tuple2(($1 as int?)!, ($2 as String?)!) as Tuple2<int, String>?;
    } else {
      state.pos = $pos;
    }
  }
  return $0;
}

Tuple3<int, String, int>? tuple3C32AbcC16(State<String> state) {
  final source = state.source;
  Tuple3<int, String, int>? $0;
  final $pos = state.pos;
  int? $1;
  $1 = char32(state);
  if (state.ok) {
    String? $2;
    $2 = tagAbc(state);
    if (state.ok) {
      int? $3;
      final $pos1 = state.pos;
      int? $4;
      state.ok = state.pos < source.length;
      if (state.ok) {
        $4 = source.codeUnitAt(state.pos++) as int?;
        state.ok = ($4 as int?)! == 80;
        if (state.ok) {
          $3 = $4;
        }
      }
      if (!state.ok) {
        state.pos = $pos1;
        state.error = ErrExpected.char(state.pos, const Char(80));
      } else {
        $0 = Tuple3(($1 as int?)!, ($2 as String?)!, ($3 as int?)!)
            as Tuple3<int, String, int>?;
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

bool? valueAbcToTrueValue(State<String> state) {
  final source = state.source;
  bool? $0;
  state.ok = state.pos < source.length &&
      source.codeUnitAt(state.pos) == 97 &&
      source.startsWith('abc', state.pos);
  if (state.ok) {
    state.pos += 3;
    $0 = true as bool?;
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('abc'));
  }
  return $0;
}

bool? valueTrue(State<dynamic> state) {
  bool? $0;
  state.ok = true;
  $0 = true as bool?;
  return $0;
}

String? transformersCharClassIsDigit(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.codeUnitAt(state.pos++) as int?;
      $c = $3!;
      state.ok = $c >= 48 && $c <= 57;
    }
    if (!state.ok) {
      state.pos = $pos1;
      break;
    }
  }
  state.ok = true;
  $0 = state.source.slice($pos, state.pos) as String?;
  return $0;
}

String? transformersClosureIsDigit(State<String> state) {
  final source = state.source;
  final $predicate = (int x) => x >= 0x30 && x <= 0x39;
  String? $0;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.readRune(state) as int?;
      $c = $3!;
      state.ok = $predicate($c);
    }
    if (!state.ok) {
      state.pos = $pos1;
      break;
    }
  }
  state.ok = true;
  $0 = state.source.slice($pos, state.pos) as String?;
  return $0;
}

String? transformersExprIsDigit(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.readRune(state) as int?;
      $c = $3!;
      state.ok = $c >= 0x30 && $c <= 0x39;
    }
    if (!state.ok) {
      state.pos = $pos1;
      break;
    }
  }
  state.ok = true;
  $0 = state.source.slice($pos, state.pos) as String?;
  return $0;
}

String? transformersFuncExprIsDigit(State<String> state) {
  final source = state.source;
  bool $predicate(int x) => x >= 0x30 && x <= 0x39;
  String? $0;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.readRune(state) as int?;
      $c = $3!;
      state.ok = $predicate($c);
    }
    if (!state.ok) {
      state.pos = $pos1;
      break;
    }
  }
  state.ok = true;
  $0 = state.source.slice($pos, state.pos) as String?;
  return $0;
}

String? transformersFuncIsDigit(State<String> state) {
  final source = state.source;
  bool $predicate(int x) {
    return x >= 0x30 && x <= 0x39;
  }

  String? $0;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.readRune(state) as int?;
      $c = $3!;
      state.ok = $predicate($c);
    }
    if (!state.ok) {
      state.pos = $pos1;
      break;
    }
  }
  state.ok = true;
  $0 = state.source.slice($pos, state.pos) as String?;
  return $0;
}

String? transformersNotCharClassIsDigit(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (true) {
    final $pos1 = state.pos;
    int? $c;
    int? $3;
    state.ok = state.pos < source.length;
    if (state.ok) {
      $3 = source.readRune(state) as int?;
      $c = $3!;
      state.ok =
          $c > 1114111 || !($c >= 0 && $c <= 47 || $c >= 58 && $c <= 1114111);
    }
    if (!state.ok) {
      state.pos = $pos1;
      break;
    }
  }
  state.ok = true;
  $0 = state.source.slice($pos, state.pos) as String?;
  return $0;
}

int? transformersVarIsNotDigit(State<String> state) {
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
  int? $0;
  List<int>? $1;
  final $v = $calculate;
  state.ok = true;
  $1 = $v as List<int>?;
  state.ok = state.pos < source.length;
  if (state.ok) {
    final pos = state.pos;
    final $c = source.readRune(state);
    final list = ($1 as List<int>?)!;
    for (var i = 0; i < list.length; i++) {
      final ch = list[i];
      if ($c == ch) {
        state.pos = pos;
        state.ok = false;
        state.error = ErrUnexpected.char(state.pos, Char($c));
        break;
      }
    }
    if (state.ok) {
      $0 = $c as int?;
    }
  } else {
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
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
