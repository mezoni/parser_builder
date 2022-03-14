// ignore_for_file: unused_local_variable

import 'package:tuple/tuple.dart';

String? alpha0(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 122 && (c >= 65 && c <= 90 || c >= 97 && c <= 122);
    if (ok) {
      state.pos++;
      continue;
    }
    break;
  }
  state.ok = true;
  if (state.ok) {
    $0 = source.substring($pos, state.pos);
  }
  return $0;
}

String? alpha1(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 122 && (c >= 65 && c <= 90 || c >= 97 && c <= 122);
    if (ok) {
      state.pos++;
      continue;
    }
    break;
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
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 122 &&
        (c >= 48 && c <= 57 || c >= 65 && c <= 90 || c >= 97 && c <= 122);
    if (ok) {
      state.pos++;
      continue;
    }
    break;
  }
  state.ok = true;
  if (state.ok) {
    $0 = source.substring($pos, state.pos);
  }
  return $0;
}

String? alphanumeric1(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 122 &&
        (c >= 48 && c <= 57 || c >= 65 && c <= 90 || c >= 97 && c <= 122);
    if (ok) {
      state.pos++;
      continue;
    }
    break;
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
  final source = state.source;
  int? $0;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 80;
  if (state.ok) {
    state.pos++;
    $0 = 80;
  } else if (state.log) {
    state.error = ErrExpected.char(state.pos, const Char(80));
  }
  return $0;
}

int? char32(State<String> state) {
  final source = state.source;
  int? $0;
  state.ok = state.pos < source.length && source.runeAt(state.pos) == 119296;
  if (state.ok) {
    state.pos += 2;
    $0 = 119296;
  } else if (state.log) {
    state.error = ErrExpected.char(state.pos, const Char(119296));
  }
  return $0;
}

int? altC16OrC32(State<String> state) {
  int? $0;
  for (;;) {
    int? $1;
    $1 = char16(state);
    if (state.ok) {
      $0 = $1;
      break;
    }
    final $2 = state.error;
    int? $3;
    $3 = char32(state);
    if (state.ok) {
      $0 = $3;
      break;
    }
    final $4 = state.error;
    if (state.log) {
      state.error = ErrCombined(state.pos, [$2, $4]);
    }
    break;
  }
  return $0;
}

int? anyChar(State<String> state) {
  final source = state.source;
  int? $0;
  state.ok = state.pos < source.length;
  if (state.ok) {
    $0 = source.readRune(state);
  } else if (state.log) {
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
}

List<int>? combinedList1C16C32(State<String> state) {
  List<int>? $0;
  final $log = state.log;
  final $list = <int>[];
  int? $1;
  $1 = char16(state);
  if (state.ok) {
    $list.add($1!);
    state.log = false;
    for (;;) {
      int? $2;
      $2 = char32(state);
      if (!state.ok) {
        break;
      }
      $list.add($2!);
    }
  }
  state.ok = $list.isNotEmpty;
  if (state.ok) {
    $0 = $list;
  }
  state.log = $log;
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
    $0 = 'abc';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('abc'));
  }
  return $0;
}

Tuple2<String, List<String>>? consumedSeparatedAbcC32(State<String> state) {
  Tuple2<String, List<String>>? $0;
  final $pos = state.pos;
  List<String>? $1;
  final $log = state.log;
  var $pos1 = state.pos;
  final $list = <String>[];
  for (;;) {
    state.log = $list.isEmpty ? $log : false;
    String? $2;
    $2 = tagAbc(state);
    if (!state.ok) {
      state.pos = $pos1;
      break;
    }
    $list.add($2!);
    $pos1 = state.pos;
    int? $3;
    $3 = char32(state);
    if (!state.ok) {
      break;
    }
  }
  if ($list.isNotEmpty) {
    state.ok = true;
    $1 = $list;
  }
  state.log = $log;
  if (state.ok) {
    final v = state.source.slice($pos, state.pos);
    $0 = Tuple2(v, $1!);
  }
  return $0;
}

int? delimited(State<String> state) {
  int? $0;
  final $pos = state.pos;
  int? $1;
  $1 = char16(state);
  if (state.ok) {
    int? $2;
    $2 = char32(state);
    if (state.ok) {
      int? $3;
      $3 = char16(state);
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

String? digit0(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c >= 48 && c <= 57;
    if (ok) {
      state.pos++;
      continue;
    }
    break;
  }
  state.ok = true;
  if (state.ok) {
    $0 = source.substring($pos, state.pos);
  }
  return $0;
}

String? digit1(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c >= 48 && c <= 57;
    if (ok) {
      state.pos++;
      continue;
    }
    break;
  }
  state.ok = state.pos != $pos;
  if (state.ok) {
    $0 = source.substring($pos, state.pos);
  } else if (state.log) {
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  return $0;
}

bool? eof(State<String> state) {
  bool? $0;
  state.ok = state.pos >= state.source.length;
  if (state.ok) {
    $0 = true;
  } else if (state.log) {
    state.error = ErrExpected.eof(state.pos);
  }
  return $0;
}

int? escapeSequence16(State<String> state) {
  final source = state.source;
  int? $0;
  state.ok = false;
  if (state.pos < source.length) {
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
    if (v != null) {
      state.pos++;
      state.ok = true;
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
  final source = state.source;
  int? $0;
  state.ok = false;
  if (state.pos < source.length) {
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
    if (v != null) {
      state.ok = true;
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
  final source = state.source;
  dynamic $0;
  final $log = state.log;
  state.log = false;
  var $acc = 0;
  for (;;) {
    int? $1;
    state.ok = false;
    if (state.pos < source.length) {
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
    final v = $1!;
    $acc = $acc * 10 + v - 0x30;
  }
  state.ok = true;
  if (state.ok) {
    $0 = $acc;
  }
  state.log = $log;
  return $0;
}

String? hexDigit0(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 102 &&
        (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102);
    if (ok) {
      state.pos++;
      continue;
    }
    break;
  }
  state.ok = true;
  if (state.ok) {
    $0 = source.substring($pos, state.pos);
  }
  return $0;
}

String? hexDigit1(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c <= 102 &&
        (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102);
    if (ok) {
      state.pos++;
      continue;
    }
    break;
  }
  state.ok = state.pos != $pos;
  if (state.ok) {
    $0 = source.substring($pos, state.pos);
  } else if (state.log) {
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  return $0;
}

List<int>? many0C32(State<String> state) {
  List<int>? $0;
  final $log = state.log;
  state.log = false;
  final $list = <int>[];
  for (;;) {
    int? $1;
    $1 = char32(state);
    if (!state.ok) {
      break;
    }
    $list.add($1!);
  }
  state.ok = true;
  if (state.ok) {
    $0 = $list;
  }
  state.log = $log;
  return $0;
}

int? many0CountC32(State<String> state) {
  int? $0;
  final $log = state.log;
  state.log = false;
  var $cnt = 0;
  while (true) {
    int? $1;
    $1 = char32(state);
    if (!state.ok) {
      break;
    }
    $cnt++;
  }
  state.ok = true;
  if (state.ok) {
    $0 = $cnt;
  }
  state.log = $log;
  return $0;
}

List<int>? many1C32(State<String> state) {
  List<int>? $0;
  final $log = state.log;
  final $list = <int>[];
  for (;;) {
    state.log = $list.isEmpty ? $log : false;
    int? $1;
    $1 = char32(state);
    if (!state.ok) {
      break;
    }
    $list.add($1!);
  }
  if ($list.isNotEmpty) {
    state.ok = true;
    $0 = $list;
  }
  state.log = $log;
  return $0;
}

int? many1CountC32(State<String> state) {
  int? $0;
  final $log = state.log;
  var $cnt = 0;
  while (true) {
    state.log = $cnt == 0 ? $log : false;
    int? $1;
    $1 = char32(state);
    if (!state.ok) {
      break;
    }
    $cnt++;
  }
  if ($cnt > 0) {
    state.ok = true;
    $0 = $cnt;
  }
  state.log = $log;
  return $0;
}

List<int>? manyMNC32_2_3(State<String> state) {
  List<int>? $0;
  final $log = state.log;
  final $pos = state.pos;
  final $list = <int>[];
  var $cnt = 0;
  while ($cnt < 3) {
    state.log = $cnt <= 2 ? $log : false;
    int? $1;
    $1 = char32(state);
    if (!state.ok) {
      break;
    }
    $list.add($1!);
    $cnt++;
  }
  state.ok = $cnt >= 2;
  if (state.ok) {
    $0 = $list;
  } else {
    state.pos = $pos;
  }
  state.log = $log;
  return $0;
}

Tuple2<List<String>, String>? manyTillAOrBTillAbc(State<String> state) {
  final source = state.source;
  Tuple2<List<String>, String>? $0;
  final $pos = state.pos;
  final $list = <String>[];
  for (;;) {
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
    String? $3;
    state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 97;
    if (state.ok) {
      state.pos++;
      $3 = 'a';
    } else if (state.log) {
      state.error = ErrExpected.tag(state.pos, const Tag('a'));
    }
    if (state.ok) {
      $2 = $3!;
    } else {
      final $error1 = state.error;
      String? $4;
      state.ok =
          state.pos < source.length && source.codeUnitAt(state.pos) == 98;
      if (state.ok) {
        state.pos++;
        $4 = 'b';
      } else if (state.log) {
        state.error = ErrExpected.tag(state.pos, const Tag('b'));
      }
      if (state.ok) {
        $2 = $4!;
      } else if (state.log) {
        state.error = ErrCombined(state.pos, [$error1, state.error]);
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
  final source = state.source;
  dynamic $0;
  final $pos = state.pos;
  int? $1;
  state.ok = false;
  if (state.pos < source.length) {
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
    state.ok = false;
    if (state.pos < source.length) {
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
      state.ok = false;
      if (state.pos < source.length) {
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
        state.ok = false;
        if (state.pos < source.length) {
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
          $0 = ($1! - 0x30) * 1000 +
              ($2! - 0x30) * 100 +
              ($3! - 0x30) * 10 +
              $4! -
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
  final source = state.source;
  String? $0;
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
  final source = state.source;
  int? $0;
  state.ok = false;
  if (state.pos < source.length) {
    final pos = state.pos;
    var c = source.readRune(state);
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

int? noneOfC16OrC32Ex(State<String> state) {
  final source = state.source;
  int? $0;
  state.ok = true;
  if (state.pos < source.length) {
    final pos = state.pos;
    var c = source.readRune(state);
    final chars = state.context.listOfC16AndC32 as List<int>;
    final list = chars;
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
  } else {
    if (state.log) {
      state.error = ErrUnexpected.eof(state.pos);
    }
    state.ok = false;
  }
  return $0;
}

int? noneOfC32(State<String> state) {
  final source = state.source;
  int? $0;
  state.ok = false;
  if (state.pos < source.length) {
    final pos = state.pos;
    var c = source.readRune(state);
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

bool? noneOfTagsAbcAbdDefDegXXY(State<String> state) {
  final source = state.source;
  bool? $0;
  state.ok = true;
  final $pos = state.pos;
  if (state.pos < source.length) {
    final c = source.codeUnitAt($pos);
    switch (c) {
      case 97:
        if (source.startsWith('abc', $pos)) {
          state.ok = false;
          if (state.log) {
            state.error = ErrUnexpected.tag($pos, const Tag('abc'));
          }
          break;
        }
        if (source.startsWith('abd', $pos)) {
          state.ok = false;
          if (state.log) {
            state.error = ErrUnexpected.tag($pos, const Tag('abd'));
          }
          break;
        }
        break;
      case 100:
        if (source.startsWith('def', $pos)) {
          state.ok = false;
          if (state.log) {
            state.error = ErrUnexpected.tag($pos, const Tag('def'));
          }
          break;
        }
        if (source.startsWith('deg', $pos)) {
          state.ok = false;
          if (state.log) {
            state.error = ErrUnexpected.tag($pos, const Tag('deg'));
          }
          break;
        }
        break;
      case 120:
        if (source.startsWith('xy', $pos)) {
          state.ok = false;
          if (state.log) {
            state.error = ErrUnexpected.tag($pos, const Tag('xy'));
          }
          break;
        }
        state.ok = false;
        if (state.log) {
          state.error = ErrUnexpected.tag($pos, const Tag('x'));
        }
        break;
    }
  }
  if (state.ok) {
    $0 = true;
  }
  return $0;
}

bool? notC32OrC16(State<String> state) {
  bool? $0;
  final $log = state.log;
  state.log = false;
  final $pos = state.pos;
  dynamic $1;
  int? $2;
  $2 = char16(state);
  if (state.ok) {
    $1 = $2!;
  } else {
    final $error = state.error;
    int? $3;
    $3 = char32(state);
    if (state.ok) {
      $1 = $3!;
    } else if (state.log) {
      state.error = ErrCombined(state.pos, [$error, state.error]);
    }
  }
  state.ok = !state.ok;
  if (state.ok) {
    $0 = true;
  } else {
    state.pos = $pos;
    if ($log) {
      state.error = ErrUnknown(state.pos);
    }
  }
  state.log = $log;
  return $0;
}

int? oneOfC16(State<String> state) {
  final source = state.source;
  int? $0;
  state.ok = false;
  if (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    state.ok = c == 80;
    if (state.ok) {
      state.pos++;
      $0 = c;
    } else if (state.log) {
      state.error =
          ErrUnexpected.char(state.pos, Char(source.runeAt(state.pos)));
    }
  } else if (state.log) {
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
}

int? oneOfC32(State<String> state) {
  final source = state.source;
  int? $0;
  state.ok = false;
  if (state.pos < source.length) {
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
  final source = state.source;
  String? $0;
  final $log = state.log;
  state.log = false;
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
    $0 = $1!;
  } else {
    state.ok = true;
    $0 = null;
  }
  state.log = $log;
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
    $0 = $1;
  }
  return $0;
}

int? precededC16C32(State<String> state) {
  int? $0;
  final $pos = state.pos;
  int? $1;
  $1 = char16(state);
  if (state.ok) {
    int? $2;
    $2 = char32(state);
    if (state.ok) {
      $0 = $2!;
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

String? recognize3C32AbcC16(State<String> state) {
  String? $0;
  final $pos = state.pos;
  Tuple3<int, String, int>? $1;
  final $pos1 = state.pos;
  int? $2;
  $2 = char32(state);
  if (state.ok) {
    String? $3;
    $3 = tagAbc(state);
    if (state.ok) {
      int? $4;
      $4 = char16(state);
      if (state.ok) {
        $1 = Tuple3($2!, $3!, $4!);
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos1;
  }
  if (state.ok) {
    $0 = state.source.slice($pos, state.pos);
  }
  return $0;
}

int? satisfyC16(State<String> state) {
  final source = state.source;
  int? $0;
  state.ok = false;
  if (state.pos < source.length) {
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
  final source = state.source;
  int? $0;
  state.ok = false;
  if (state.pos < source.length) {
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
  final source = state.source;
  List<int>? $0;
  final $log = state.log;
  state.log = false;
  var $pos = state.pos;
  final $list = <int>[];
  for (;;) {
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
    String? $2;
    state.ok = state.pos < source.length &&
        source.codeUnitAt(state.pos) == 97 &&
        source.startsWith('abc', state.pos);
    if (state.ok) {
      state.pos += 3;
      $2 = 'abc';
    } else if (state.log) {
      state.error = ErrExpected.tag(state.pos, const Tag('abc'));
    }
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

List<int>? separatedList1C32Abc(State<String> state) {
  final source = state.source;
  List<int>? $0;
  final $log = state.log;
  var $pos = state.pos;
  final $list = <int>[];
  for (;;) {
    state.log = $list.isEmpty ? $log : false;
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
    String? $2;
    state.ok = state.pos < source.length &&
        source.codeUnitAt(state.pos) == 97 &&
        source.startsWith('abc', state.pos);
    if (state.ok) {
      state.pos += 3;
      $2 = 'abc';
    } else if (state.log) {
      state.error = ErrExpected.tag(state.pos, const Tag('abc'));
    }
    if (!state.ok) {
      break;
    }
  }
  if ($list.isNotEmpty) {
    state.ok = true;
    $0 = $list;
  }
  state.log = $log;
  return $0;
}

Tuple2<int, int>? separatedPairC16AbcC32(State<String> state) {
  final source = state.source;
  Tuple2<int, int>? $0;
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
    String? $2;
    state.ok = state.pos < source.length &&
        source.codeUnitAt(state.pos) == 97 &&
        source.startsWith('abc', state.pos);
    if (state.ok) {
      state.pos += 3;
      $2 = 'abc';
    } else if (state.log) {
      state.error = ErrExpected.tag(state.pos, const Tag('abc'));
    }
    if (state.ok) {
      int? $3;
      state.ok =
          state.pos < source.length && source.runeAt(state.pos) == 119296;
      if (state.ok) {
        state.pos += 2;
        $3 = 119296;
      } else if (state.log) {
        state.error = ErrExpected.char(state.pos, const Char(119296));
      }
      if (state.ok) {
        $0 = Tuple2($1!, $3!);
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos;
  }
  return $0;
}

bool? sequenceC16C32(State<String> state) {
  bool? $0;
  final $pos = state.pos;
  int? $1;
  $1 = char16(state);
  if (state.ok) {
    int? $2;
    $2 = char32(state);
    if (state.ok) {
      $0 = true;
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
    $0 = 'ABC';
  } else if (state.log) {
    state.error = ErrUnexpected.eof(source.length);
  }
  return $0;
}

bool? skipWhile1C16(State<String> state) {
  final source = state.source;
  bool? $0;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c == 80;
    if (ok) {
      state.pos++;
      continue;
    }
    break;
  }
  state.ok = state.pos != $pos;
  if (state.ok) {
    $0 = true;
  } else if (state.log) {
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  return $0;
}

bool? skipWhile1C32(State<String> state) {
  final source = state.source;
  bool? $0;
  final $pos = state.pos;
  var $c = 0;
  while (state.pos < source.length) {
    final pos = state.pos;
    $c = source.readRune(state);
    final ok = $c == 119296;
    if (ok) {
      continue;
    }
    state.pos = pos;
    break;
  }
  state.ok = state.pos != $pos;
  if (state.ok) {
    $0 = true;
  } else if (state.log) {
    state.error = ErrUnexpected.charOrEof(state.pos, source, $c);
  }
  return $0;
}

bool? skipWhileC16(State<String> state) {
  final source = state.source;
  bool? $0;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c == 80;
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

bool? skipWhileC32(State<String> state) {
  final source = state.source;
  bool? $0;
  while (state.pos < source.length) {
    final pos = state.pos;
    final c = source.readRune(state);
    final ok = c == 119296;
    if (ok) {
      continue;
    }
    state.pos = pos;
    break;
  }
  state.ok = true;
  if (state.ok) {
    $0 = true;
  }
  return $0;
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
    state.ok = false;
    if (state.pos < source.length) {
      var c = source.codeUnitAt(state.pos);
      int? v;
      switch (c) {
        case 110:
          v = 10;
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
    if (!state.ok) {
      state.pos = $pos;
      break;
    }
    if ($list.isEmpty && $str != '') {
      $list.add($str);
    }
    $list.add($1!);
  }
  if (state.ok) {
    if ($list.isEmpty) {
      $0 = $str;
    } else if ($list.length == 1) {
      final c = $list[0] as int;
      $0 = String.fromCharCode(c);
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
      $0 = buffer.toString();
    }
  }
  return $0;
}

dynamic switchTag(State<String> state) {
  final source = state.source;
  dynamic $0;
  final $pos = state.pos;
  var $matched = false;
  state.ok = false;
  if ($pos < source.length) {
    final c = source.codeUnitAt($pos);
    switch (c) {
      case 110:
        if (source.startsWith('null', $pos)) {
          $matched = true;
          dynamic $1;
          String? $2;
          state.ok = state.pos < source.length &&
              source.codeUnitAt(state.pos) == 110 &&
              source.startsWith('null', state.pos);
          if (state.ok) {
            state.pos += 4;
            $2 = 'null';
          } else if (state.log) {
            state.error = ErrExpected.tag(state.pos, const Tag('null'));
          }
          if (state.ok) {
            $1 = null;
          }
          if (state.ok) {
            $0 = $1;
          }
          break;
        }
        $matched = true;
        dynamic $3;
        String? $4;
        state.ok =
            state.pos < source.length && source.codeUnitAt(state.pos) == 110;
        if (state.ok) {
          state.pos++;
          $4 = 'n';
        } else if (state.log) {
          state.error = ErrExpected.tag(state.pos, const Tag('n'));
        }
        if (state.ok) {
          $3 = 'n';
        }
        if (state.ok) {
          $0 = $3;
        }
        break;
      case 102:
        if (source.startsWith('false', $pos)) {
          $matched = true;
          dynamic $5;
          state.ok = state.pos + 5 <= source.length;
          if (state.ok) {
            state.pos += 5;
            $5 = false;
          } else if (state.log) {
            state.error = ErrUnexpected.eof(source.length);
          }
          if (state.ok) {
            $0 = $5;
          }
          break;
        }
        break;
      case 116:
        if (source.startsWith('true', $pos)) {
          $matched = true;
          dynamic $6;
          String? $7;
          state.ok = state.pos < source.length &&
              source.codeUnitAt(state.pos) == 116 &&
              source.startsWith('true', state.pos);
          if (state.ok) {
            state.pos += 4;
            $7 = 'true';
          } else if (state.log) {
            state.error = ErrExpected.tag(state.pos, const Tag('true'));
          }
          if (state.ok) {
            $6 = true;
          }
          if (state.ok) {
            $0 = $6;
          }
          break;
        }
        break;
    }
  }
  if (!state.ok) {
    $matched = true;
    dynamic $8;
    String? $9;
    final $pos1 = state.pos;
    while (state.pos < source.length) {
      final c = source.codeUnitAt(state.pos);
      final ok = c >= 48 && c <= 57;
      if (ok) {
        state.pos++;
        continue;
      }
      break;
    }
    state.ok = state.pos != $pos1;
    if (state.ok) {
      $9 = source.substring($pos1, state.pos);
    } else if (state.log) {
      state.error = ErrUnexpected.charOrEof(state.pos, source);
    }
    if (state.ok) {
      $8 = $9!;
    } else {
      final $error = state.error;
      String? $10;
      final $pos2 = state.pos;
      while (state.pos < source.length) {
        final c = source.codeUnitAt(state.pos);
        final ok = c <= 122 && (c >= 65 && c <= 90 || c >= 97 && c <= 122);
        if (ok) {
          state.pos++;
          continue;
        }
        break;
      }
      state.ok = state.pos != $pos2;
      if (state.ok) {
        $10 = source.substring($pos2, state.pos);
      } else if (state.log) {
        state.error = ErrUnexpected.charOrEof(state.pos, source);
      }
      if (state.ok) {
        $8 = $10!;
      } else if (state.log) {
        state.error = ErrCombined(state.pos, [$error, state.error]);
      }
    }
    if (state.ok) {
      $0 = $8;
    }
  }
  if (!state.ok && state.log) {
    final List<Err> errors = [
      ErrExpected.tag(state.pos, const Tag('alphas')),
      ErrExpected.tag(state.pos, const Tag('digits')),
      ErrExpected.tag(state.pos, const Tag('false')),
      ErrExpected.tag(state.pos, const Tag('n')),
      ErrExpected.tag(state.pos, const Tag('null')),
      ErrExpected.tag(state.pos, const Tag('true'))
    ];
    if ($matched) {
      errors.add(state.error);
    }
    state.error = ErrCombined(state.pos, errors);
  }
  return $0;
}

String? tagC16(State<String> state) {
  final source = state.source;
  String? $0;
  state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == 80;
  if (state.ok) {
    state.pos++;
    $0 = 'P';
  } else if (state.log) {
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
    $0 = 'P𝈀';
  } else if (state.log) {
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
    $0 = '𝈀';
  } else if (state.log) {
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
    $0 = '𝈀P';
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, const Tag('𝈀P'));
  }
  return $0;
}

String? tagExFoo(State<String> state) {
  final source = state.source;
  String? $0;
  final $get = state.context.foo as String;
  final $tag = $get;
  state.ok = source.startsWith($tag, state.pos);
  if (state.ok) {
    state.pos += $tag.length;
    $0 = $tag;
  } else if (state.log) {
    state.error = ErrExpected.tag(state.pos, Tag($tag));
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
      state.ok = true;
      state.pos += 3;
      $0 = v1;
    }
  }
  if (!state.ok && state.log) {
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
          $0 = 'abc';
          break;
        }
        if (source.startsWith('abd', $pos)) {
          state.pos += 3;
          state.ok = true;
          $0 = 'abd';
          break;
        }
        break;
      case 100:
        if (source.startsWith('def', $pos)) {
          state.pos += 3;
          state.ok = true;
          $0 = 'def';
          break;
        }
        if (source.startsWith('deg', $pos)) {
          state.pos += 3;
          state.ok = true;
          $0 = 'deg';
          break;
        }
        break;
      case 120:
        if (source.startsWith('xy', $pos)) {
          state.pos += 2;
          state.ok = true;
          $0 = 'xy';
          break;
        }
        state.pos++;
        state.ok = true;
        $0 = 'x';
        break;
    }
  }
  if (!state.ok && state.log) {
    state.error = ErrCombined($pos, [
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
  final source = state.source;
  String? $0;
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
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  final $index = source.indexOf('abc', $pos);
  state.ok = $index > $pos;
  if (state.ok) {
    state.pos = $index;
    $0 = source.substring($pos, $index);
  } else if (state.log) {
    state.error = ErrExpected.tag($pos, const Tag('abc'));
  }
  return $0;
}

String? takeWhile1C16(State<String> state) {
  final source = state.source;
  String? $0;
  state.ok = false;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c == 80;
    if (ok) {
      state.pos++;
      continue;
    }
    break;
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
  final source = state.source;
  String? $0;
  state.ok = false;
  final $pos = state.pos;
  var $c = 0;
  while (state.pos < source.length) {
    final pos = state.pos;
    $c = source.readRune(state);
    final ok = $c == 119296;
    if (ok) {
      continue;
    }
    state.pos = pos;
    break;
  }
  state.ok = state.pos != $pos;
  if (state.ok) {
    $0 = source.substring($pos, state.pos);
  } else if (state.log) {
    state.error = ErrUnexpected.charOrEof(state.pos, source, $c);
  }
  return $0;
}

dynamic takeWhile1DigitFold(State<String> state) {
  final source = state.source;
  dynamic $0;
  final $pos = state.pos;
  var $acc = 0;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c >= 48 && c <= 57;
    if (ok) {
      $acc = $acc * 10 + c - 0x30;
      state.pos++;
      continue;
    }
    break;
  }
  state.ok = state.pos != $pos;
  if (state.ok) {
    $0 = $acc;
  } else if (state.log) {
    state.error = ErrUnexpected.charOrEof(state.pos, source);
  }
  return $0;
}

String? takeWhileC16(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c == 80;
    if (ok) {
      state.pos++;
      continue;
    }
    break;
  }
  state.ok = true;
  if (state.ok) {
    $0 = $pos == state.pos ? '' : source.substring($pos, state.pos);
  }
  return $0;
}

String? takeWhileC16UntilAbc(State<String> state) {
  final source = state.source;
  String? $0;
  final $index = source.indexOf('abc', state.pos);
  if ($index != -1) {
    final pos = state.pos;
    var c = 0;
    while (state.pos < $index) {
      c = source.codeUnitAt(state.pos);
      final ok = c == 80;
      if (ok) {
        state.pos++;
        continue;
      }
      break;
    }
    state.ok = state.pos == $index;
    if (state.ok) {
      $0 = source.substring(pos, state.pos);
    } else {
      if (state.log) {
        state.error = ErrUnexpected.charAt(state.pos, source);
      }
      state.pos = pos;
    }
  } else {
    state.ok = false;
    if (state.log) {
      state.error = ErrExpected.tag(state.pos, const Tag('abc'));
    }
  }
  return $0;
}

String? takeWhileC32UntilAbc(State<String> state) {
  final source = state.source;
  String? $0;
  final $index = source.indexOf('abc', state.pos);
  if ($index != -1) {
    final pos = state.pos;
    var c = 0;
    while (state.pos < $index) {
      final pos = state.pos;
      c = source.readRune(state);
      final ok = c == 119296;
      if (ok) {
        continue;
      }
      state.pos = pos;
      break;
    }
    state.ok = state.pos == $index;
    if (state.ok) {
      $0 = source.substring(pos, state.pos);
    } else {
      if (state.log) {
        state.error = ErrUnexpected.char(state.pos, Char(c));
      }
      state.pos = pos;
    }
  } else {
    state.ok = false;
    if (state.log) {
      state.error = ErrExpected.tag(state.pos, const Tag('abc'));
    }
  }
  return $0;
}

String? takeWhileC32(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final pos = state.pos;
    var c = source.readRune(state);
    final ok = c == 119296;
    if (ok) {
      continue;
    }
    state.pos = pos;
    break;
  }
  state.ok = true;
  if (state.ok) {
    $0 = $pos == state.pos ? '' : source.substring($pos, state.pos);
  }
  return $0;
}

String? takeWhileMN_2_4C16(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  var $cnt = 0;
  while ($cnt < 4 && state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c == 80;
    if (ok) {
      state.pos++;
      $cnt++;
      continue;
    }
    break;
  }
  state.ok = $cnt >= 2;
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
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  var $c = 0;
  var $cnt = 0;
  while ($cnt < 4 && state.pos < source.length) {
    final pos = state.pos;
    $c = source.readRune(state);
    final ok = $c == 119296;
    if (ok) {
      $cnt++;
      continue;
    }
    state.pos = pos;
    break;
  }
  state.ok = $cnt >= 2;
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
  int? $1;
  $1 = char16(state);
  if (state.ok) {
    int? $2;
    $2 = char32(state);
    if (state.ok) {
      $0 = $1!;
    }
  }
  if (!state.ok) {
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
  final $pos = state.pos;
  int? $1;
  $1 = char32(state);
  if (state.ok) {
    String? $2;
    $2 = tagAbc(state);
    if (state.ok) {
      int? $3;
      $3 = char16(state);
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
  final source = state.source;
  bool? $0;
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
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final c = source.codeUnitAt(state.pos);
    final ok = c >= 48 && c <= 57;
    if (ok) {
      state.pos++;
      continue;
    }
    break;
  }
  state.ok = true;
  if (state.ok) {
    $0 = $pos == state.pos ? '' : source.substring($pos, state.pos);
  }
  return $0;
}

String? transformersClosureIsDigit(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  final $cond = (int x) => x >= 0x30 && x <= 0x39;
  while (state.pos < source.length) {
    final pos = state.pos;
    var c = source.readRune(state);
    final ok = $cond(c);
    if (ok) {
      continue;
    }
    state.pos = pos;
    break;
  }
  state.ok = true;
  if (state.ok) {
    $0 = $pos == state.pos ? '' : source.substring($pos, state.pos);
  }
  return $0;
}

String? transformersExprIsDigit(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final pos = state.pos;
    var c = source.readRune(state);
    final ok = c >= 0x30 && c <= 0x39;
    if (ok) {
      continue;
    }
    state.pos = pos;
    break;
  }
  state.ok = true;
  if (state.ok) {
    $0 = $pos == state.pos ? '' : source.substring($pos, state.pos);
  }
  return $0;
}

String? transformersFuncExprIsDigit(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  bool $cond(int x) => x >= 0x30 && x <= 0x39;
  while (state.pos < source.length) {
    final pos = state.pos;
    var c = source.readRune(state);
    final ok = $cond(c);
    if (ok) {
      continue;
    }
    state.pos = pos;
    break;
  }
  state.ok = true;
  if (state.ok) {
    $0 = $pos == state.pos ? '' : source.substring($pos, state.pos);
  }
  return $0;
}

String? transformersFuncIsDigit(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  bool $cond(int x) {
    return x >= 0x30 && x <= 0x39;
  }

  while (state.pos < source.length) {
    final pos = state.pos;
    var c = source.readRune(state);
    final ok = $cond(c);
    if (ok) {
      continue;
    }
    state.pos = pos;
    break;
  }
  state.ok = true;
  if (state.ok) {
    $0 = $pos == state.pos ? '' : source.substring($pos, state.pos);
  }
  return $0;
}

String? transformersNotCharClassIsDigit(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  while (state.pos < source.length) {
    final pos = state.pos;
    var c = source.readRune(state);
    final ok = c > 1114111 || !(c >= 0 && c <= 47 || c >= 58 && c <= 1114111);
    if (ok) {
      continue;
    }
    state.pos = pos;
    break;
  }
  state.ok = true;
  if (state.ok) {
    $0 = $pos == state.pos ? '' : source.substring($pos, state.pos);
  }
  return $0;
}

int? transformersVarIsNotDigit(State<String> state) {
  final source = state.source;
  int? $0;
  state.ok = true;
  if (state.pos < source.length) {
    final pos = state.pos;
    var c = source.readRune(state);
    final chars = const [
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
    final list = chars;
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
  } else {
    if (state.log) {
      state.error = ErrUnexpected.eof(state.pos);
    }
    state.ok = false;
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
  int _furthest = 0;

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

      final furthest =
          inner.map((e) => _max(e.offset, e._furthest)).reduce(_max);
      inner.removeWhere((e) => _max(e.offset, e._furthest) < furthest);
      final maxEnd = inner.map((e) => e.offset + e.length).reduce(_max);
      final offset = error.offset;
      result.add(ErrExpected.tag(offset, error.tag).._furthest = furthest);
      if (furthest > offset) {
        result.add(ErrMessage(offset, maxEnd - offset, error.message)
          .._furthest = furthest);
        result.addAll(inner);
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

  static List<Err> _preprocess(Err error) {
    final result = <Err>[];
    _flatten(error, result);
    return result.toSet().toList();
  }

  static List<Err> _postprocess(List<Err> errors) {
    final result = errors.toList();
    final furthest = result.isEmpty
        ? -1
        : result.map((e) => _max(e.offset, e._furthest)).reduce(_max);
    result.removeWhere((e) => _max(e.offset, e._furthest) < furthest);
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

class ErrNested extends ErrWithErrors {
  @override
  final List<Err> errors;

  final String message;

  @override
  final int offset;

  final Tag tag;

  ErrNested(this.offset, this.message, this.tag, this.errors);

  @override
  int get length => 0;

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
