// ignore_for_file: unused_local_variable

import 'package:tuple/tuple.dart';

String? alpha0(State<String> state) {
  String? $0;
  final $pos = state.pos;
  var $c = state.ch;
  bool $test(int c) => c >= 0x41 && c <= 0x5a || c >= 0x61 && c <= 0x7a;
  while ($c != State.eof && $test($c)) {
    $c = state.nextChar();
  }
  state.ok = true;
  if (state.ok) {
    $0 = state.source.substring($pos, state.pos);
  }
  return $0;
}

String? alpha1(State<String> state) {
  String? $0;
  state.ok = false;
  final $pos = state.pos;
  var $c = state.ch;
  bool $test(int c) => c >= 0x41 && c <= 0x5a || c >= 0x61 && c <= 0x7a;
  while ($c != State.eof && $test($c)) {
    $c = state.nextChar();
    state.ok = true;
  }
  if (state.ok) {
    $0 = state.source.substring($pos, state.pos);
  } else {
    state.error = $c == State.eof
        ? ErrUnexpected.eof($pos)
        : ErrUnexpected.char($pos, Char($c));
  }
  return $0;
}

String? alphanumeric0(State<String> state) {
  String? $0;
  final $pos = state.pos;
  var $c = state.ch;
  bool $test(int c) =>
      c >= 0x30 && c <= 0x39 ||
      c >= 0x41 && c <= 0x5a ||
      c >= 0x61 && c <= 0x7a;
  while ($c != State.eof && $test($c)) {
    $c = state.nextChar();
  }
  state.ok = true;
  if (state.ok) {
    $0 = state.source.substring($pos, state.pos);
  }
  return $0;
}

String? alphanumeric1(State<String> state) {
  String? $0;
  state.ok = false;
  final $pos = state.pos;
  var $c = state.ch;
  bool $test(int c) =>
      c >= 0x30 && c <= 0x39 ||
      c >= 0x41 && c <= 0x5a ||
      c >= 0x61 && c <= 0x7a;
  while ($c != State.eof && $test($c)) {
    $c = state.nextChar();
    state.ok = true;
  }
  if (state.ok) {
    $0 = state.source.substring($pos, state.pos);
  } else {
    state.error = $c == State.eof
        ? ErrUnexpected.eof($pos)
        : ErrUnexpected.char($pos, Char($c));
  }
  return $0;
}

int? char16(State<String> state) {
  int? $0;
  state.ok = state.ch == 0x50;
  if (state.ok) {
    $0 = 0x50;
    state.nextChar();
  } else {
    state.error = ErrExpected.char(state.pos, const Char(0x50));
  }
  return $0;
}

int? char32(State<String> state) {
  int? $0;
  state.ok = state.ch == 0x1D200;
  if (state.ok) {
    $0 = 0x1D200;
    state.nextChar();
  } else {
    state.error = ErrExpected.char(state.pos, const Char(0x1D200));
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
    state.error = ErrCombined(state.pos, [$2, $4]);
    break;
  }
  return $0;
}

int? anyChar(State<String> state) {
  int? $0;
  state.ok = state.ch != State.eof;
  if (state.ok) {
    $0 = state.ch;
    state.nextChar();
  } else {
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
}

String? tagAbc(State<String> state) {
  String? $0;
  state.ok = state.ch == 0x61 && state.source.startsWith('abc', state.pos);
  if (state.ok) {
    state.readChar(state.pos + 3);
    $0 = 'abc';
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
  var $ch = state.ch;
  final $list = <String>[];
  for (;;) {
    String? $2;
    $2 = tagAbc(state);
    if (!state.ok) {
      state.pos = $pos1;
      state.ch = $ch;
      break;
    }
    $list.add($2!);
    $pos1 = state.pos;
    $ch = state.ch;
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
  if (state.ok) {
    final v = state.source.slice($pos, state.pos);
    $0 = Tuple2(v, $1!);
  }
  return $0;
}

String? crlf(State<String> state) {
  String? $0;
  state.ok = false;
  if (state.ch == 0xD) {
    final pos = state.pos;
    final ch = state.ch;
    if (state.nextChar() == 0xA) {
      state.nextChar();
      state.ok = true;
      $0 = '\r\n';
    } else {
      state.error = ErrExpected.char(state.pos, const Char(0xA));
      state.pos = pos;
      state.ch = ch;
    }
  } else {
    state.error = ErrExpected.char(state.pos, const Char(0xD));
  }
  return $0;
}

int? delimited(State<String> state) {
  int? $0;
  final $pos = state.pos;
  final $ch = state.ch;
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
    state.ch = $ch;
  }
  return $0;
}

String? digit0(State<String> state) {
  String? $0;
  final $pos = state.pos;
  var $c = state.ch;
  bool $test(int c) => c >= 0x30 && c <= 0x39;
  while ($c != State.eof && $test($c)) {
    $c = state.nextChar();
  }
  state.ok = true;
  if (state.ok) {
    $0 = state.source.substring($pos, state.pos);
  }
  return $0;
}

String? digit1(State<String> state) {
  String? $0;
  state.ok = false;
  final $pos = state.pos;
  var $c = state.ch;
  bool $test(int c) => c >= 0x30 && c <= 0x39;
  while ($c != State.eof && $test($c)) {
    $c = state.nextChar();
    state.ok = true;
  }
  if (state.ok) {
    $0 = state.source.substring($pos, state.pos);
  } else {
    state.error = $c == State.eof
        ? ErrUnexpected.eof($pos)
        : ErrUnexpected.char($pos, Char($c));
  }
  return $0;
}

bool? eof(State<String> state) {
  bool? $0;
  state.ok = state.source.atEnd(state.pos);
  if (state.ok) {
    $0 = true;
  } else {
    state.error = ErrExpected.eof(state.pos);
  }
  return $0;
}

String? hexDigit0(State<String> state) {
  String? $0;
  final $pos = state.pos;
  var $c = state.ch;
  bool $test(int c) =>
      c >= 0x30 && c <= 0x39 ||
      c >= 0x41 && c <= 0x46 ||
      c >= 0x61 && c <= 0x66;
  while ($c != State.eof && $test($c)) {
    $c = state.nextChar();
  }
  state.ok = true;
  if (state.ok) {
    $0 = state.source.substring($pos, state.pos);
  }
  return $0;
}

String? hexDigit1(State<String> state) {
  String? $0;
  state.ok = false;
  final $pos = state.pos;
  var $c = state.ch;
  bool $test(int c) =>
      c >= 0x30 && c <= 0x39 ||
      c >= 0x41 && c <= 0x46 ||
      c >= 0x61 && c <= 0x66;
  while ($c != State.eof && $test($c)) {
    $c = state.nextChar();
    state.ok = true;
  }
  if (state.ok) {
    $0 = state.source.substring($pos, state.pos);
  } else {
    state.error = $c == State.eof
        ? ErrUnexpected.eof($pos)
        : ErrUnexpected.char($pos, Char($c));
  }
  return $0;
}

String? lineEnding(State<String> state) {
  String? $0;
  state.ok = false;
  switch (state.ch) {
    case 0xA:
      state.nextChar();
      state.ok = true;
      $0 = '\n';
      break;
    case 0xD:
      final pos = state.pos;
      final ch = state.ch;
      switch (state.nextChar()) {
        case 0xA:
          state.nextChar();
          state.ok = true;
          $0 = '\r\n';
          break;
        default:
          state.error = ErrExpected.char(state.pos, const Char(0xA));
          state.pos = pos;
          state.ch = ch;
      }
      break;
    case State.eof:
      state.error = ErrUnexpected.eof(state.pos);
      break;
    default:
      state.error = ErrUnexpected.char(state.pos, Char(state.ch));
  }
  return $0;
}

List<int>? many0C32(State<String> state) {
  List<int>? $0;
  final $list = <int>[];
  for (;;) {
    int? $1;
    $1 = char32(state);
    if (!state.ok) {
      state.ok = true;
      if (state.ok) {
        $0 = $list;
      }
      break;
    }
    $list.add($1!);
  }
  return $0;
}

int? many0CountC32(State<String> state) {
  int? $0;
  var $cnt = 0;
  while (true) {
    int? $1;
    $1 = char32(state);
    if (!state.ok) {
      state.ok = true;
      $0 = $cnt;
      break;
    }
    $cnt++;
  }
  return $0;
}

List<int>? many1C32(State<String> state) {
  List<int>? $0;
  final $list = <int>[];
  for (;;) {
    int? $1;
    $1 = char32(state);
    if (!state.ok) {
      if ($list.isNotEmpty) {
        state.ok = true;
        $0 = $list;
      }
      break;
    }
    $list.add($1!);
  }
  return $0;
}

int? many1CountC32(State<String> state) {
  int? $0;
  var $cnt = 0;
  while (true) {
    int? $1;
    $1 = char32(state);
    if (!state.ok) {
      if ($cnt > 0) {
        state.ok = true;
        $0 = $cnt;
      }
      break;
    }
    $cnt++;
  }
  return $0;
}

List<int>? manyMNC32_2_3(State<String> state) {
  List<int>? $0;
  final $pos = state.pos;
  final $ch = state.ch;
  final $list = <int>[];
  var $cnt = 0;
  while ($cnt < 3) {
    int? $1;
    $1 = char32(state);
    if (!state.ok) {
      break;
    }
    $list.add($1!);
    $cnt++;
  }
  if ($cnt >= 2) {
    state.ok = true;
    $0 = $list;
  } else {
    state.pos = $pos;
    state.ch = $ch;
  }
  return $0;
}

Tuple2<List<String>, String>? manyTillAOrBTillAbc(State<String> state) {
  Tuple2<List<String>, String>? $0;
  final $pos = state.pos;
  final $ch = state.ch;
  final $list = <String>[];
  for (;;) {
    String? $1;
    state.ok = state.ch == 0x61 && state.source.startsWith('abc', state.pos);
    if (state.ok) {
      state.readChar(state.pos + 3);
      $1 = 'abc';
    } else {
      state.error = ErrExpected.tag(state.pos, const Tag('abc'));
    }
    if (state.ok) {
      $0 = Tuple2($list, $1!);
      break;
    }
    String? $2;
    for (;;) {
      String? $3;
      state.ok = state.ch == 0x61;
      if (state.ok) {
        state.nextChar();
        $3 = 'a';
      } else {
        state.error = ErrExpected.tag(state.pos, const Tag('a'));
      }
      if (state.ok) {
        $2 = $3;
        break;
      }
      final $4 = state.error;
      String? $5;
      state.ok = state.ch == 0x62;
      if (state.ok) {
        state.nextChar();
        $5 = 'b';
      } else {
        state.error = ErrExpected.tag(state.pos, const Tag('b'));
      }
      if (state.ok) {
        $2 = $5;
        break;
      }
      final $6 = state.error;
      state.error = ErrCombined(state.pos, [$4, $6]);
      break;
    }
    if (!state.ok) {
      state.pos = $pos;
      state.ch = $ch;
      break;
    }
    $list.add($2!);
  }
  return $0;
}

String? mapC32ToStr(State<String> state) {
  String? $0;
  int? $1;
  state.ok = state.ch == 0x1D200;
  if (state.ok) {
    $1 = 0x1D200;
    state.nextChar();
  } else {
    state.error = ErrExpected.char(state.pos, const Char(0x1D200));
  }
  if (state.ok) {
    String map(int c) => String.fromCharCode(c);
    $0 = map($1!);
  }
  return $0;
}

int? noneOfC16OrC32(State<String> state) {
  int? $0;
  final $c = state.ch;
  if ($c != State.eof) {
    state.ok = $c != 0x50 && $c != 0x1D200;
    if (state.ok) {
      $0 = $c;
      state.nextChar();
    } else {
      state.error = ErrUnexpected.char(state.pos, Char($c));
    }
  } else {
    state.ok = false;
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
}

int? noneOfC16OrC32Ex(State<String> state) {
  int? $0;
  state.ok = true;
  final $c = state.ch;
  if ($c != State.eof) {
    List<int> get(dynamic x) => state.context.listOfC16AndC32 as List<int>;
    final list = get(null);
    for (var i = 0; i < list.length; i++) {
      final c = list[i];
      if ($c == c) {
        state.ok = false;
        state.error = ErrUnexpected.char(state.pos, Char($c));
        break;
      }
    }
    if (state.ok) {
      $0 = $c;
      state.nextChar();
    }
  } else {
    state.ok = false;
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
}

bool? noneOfTagsAbcAbdDefDegX(State<String> state) {
  final source = state.source;
  bool? $0;
  state.ok = true;
  switch (state.ch) {
    case 97:
      if (source.startsWith('abc', state.pos)) {
        state.ok = false;
        state.error = ErrUnexpected.tag(state.pos, const Tag('abc'));
        break;
      }
      if (source.startsWith('abd', state.pos)) {
        state.ok = false;
        state.error = ErrUnexpected.tag(state.pos, const Tag('abd'));
        break;
      }
      break;
    case 100:
      if (source.startsWith('def', state.pos)) {
        state.ok = false;
        state.error = ErrUnexpected.tag(state.pos, const Tag('def'));
        break;
      }
      if (source.startsWith('deg', state.pos)) {
        state.ok = false;
        state.error = ErrUnexpected.tag(state.pos, const Tag('deg'));
        break;
      }
      break;
    case 120:
      if (source.startsWith('x', state.pos)) {
        state.ok = false;
        state.error = ErrUnexpected.tag(state.pos, const Tag('x'));
        break;
      }
      break;
  }
  if (state.ok) {
    $0 = true;
  }
  return $0;
}

bool? notC32OrC16(State<String> state) {
  bool? $0;
  final $pos = state.pos;
  final $ch = state.ch;
  dynamic $1;
  for (;;) {
    int? $2;
    $2 = char16(state);
    if (state.ok) {
      $1 = $2;
      break;
    }
    final $3 = state.error;
    int? $4;
    $4 = char32(state);
    if (state.ok) {
      $1 = $4;
      break;
    }
    final $5 = state.error;
    state.error = ErrCombined(state.pos, [$3, $5]);
    break;
  }
  state.ok = !state.ok;
  if (state.ok) {
    $0 = true;
  } else {
    state.pos = $pos;
    state.ch = $ch;
    state.error = ErrUnknown(state.pos);
  }
  return $0;
}

int? oneOfC16OrC32(State<String> state) {
  int? $0;
  final $c = state.ch;
  if ($c != State.eof) {
    state.ok = $c == 0x50 || $c == 0x1D200;
    if (state.ok) {
      $0 = $c;
      state.nextChar();
    } else {
      state.error = ErrUnexpected.char(state.pos, Char($c));
    }
  } else {
    state.ok = false;
    state.error = ErrUnexpected.eof(state.pos);
  }
  return $0;
}

String? optAbc(State<String> state) {
  String? $0;
  String? $1;
  state.ok = state.ch == 0x61 && state.source.startsWith('abc', state.pos);
  if (state.ok) {
    state.readChar(state.pos + 3);
    $1 = 'abc';
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('abc'));
  }
  if (state.ok) {
    $0 = $1!;
  } else {
    state.ok = true;
    $0 = null;
  }
  return $0;
}

Tuple2<int, int>? pairC16C32(State<String> state) {
  Tuple2<int, int>? $0;
  final $pos = state.pos;
  final $ch = state.ch;
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
    state.ch = $ch;
  }
  return $0;
}

int? peekC32(State<String> state) {
  int? $0;
  final $pos = state.pos;
  final $ch = state.ch;
  int? $1;
  $1 = char32(state);
  if (state.ok) {
    state.pos = $pos;
    state.ch = $ch;
    $0 = $1;
  }
  return $0;
}

int? precededC16C32(State<String> state) {
  int? $0;
  final $pos = state.pos;
  final $ch = state.ch;
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
    state.ch = $ch;
  }
  return $0;
}

String? recognize3C32AbcC16(State<String> state) {
  String? $0;
  final $pos = state.pos;
  Tuple3<int, String, int>? $1;
  final $pos1 = state.pos;
  final $ch = state.ch;
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
    state.ch = $ch;
  }
  if (state.ok) {
    $0 = state.source.slice($pos, state.pos);
  }
  return $0;
}

int? satisfyIsC32(State<String> state) {
  int? $0;
  final $c = state.ch;
  bool $test(int c) => c == 0x1d200;
  state.ok = $c != State.eof && $test($c);
  if (state.ok) {
    $0 = $c;
    state.nextChar();
  } else {
    state.error = $c == State.eof
        ? ErrUnexpected.eof(state.pos)
        : ErrUnexpected.char(state.pos, Char($c));
  }
  return $0;
}

List<int>? separatedList0C32Abc(State<String> state) {
  List<int>? $0;
  var $pos = state.pos;
  var $ch = state.ch;
  final $list = <int>[];
  for (;;) {
    int? $1;
    state.ok = state.ch == 0x1D200;
    if (state.ok) {
      $1 = 0x1D200;
      state.nextChar();
    } else {
      state.error = ErrExpected.char(state.pos, const Char(0x1D200));
    }
    if (!state.ok) {
      state.pos = $pos;
      state.ch = $ch;
      break;
    }
    $list.add($1!);
    $pos = state.pos;
    $ch = state.ch;
    String? $2;
    state.ok = state.ch == 0x61 && state.source.startsWith('abc', state.pos);
    if (state.ok) {
      state.readChar(state.pos + 3);
      $2 = 'abc';
    } else {
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
  return $0;
}

List<int>? separatedList1C32Abc(State<String> state) {
  List<int>? $0;
  var $pos = state.pos;
  var $ch = state.ch;
  final $list = <int>[];
  for (;;) {
    int? $1;
    state.ok = state.ch == 0x1D200;
    if (state.ok) {
      $1 = 0x1D200;
      state.nextChar();
    } else {
      state.error = ErrExpected.char(state.pos, const Char(0x1D200));
    }
    if (!state.ok) {
      state.pos = $pos;
      state.ch = $ch;
      break;
    }
    $list.add($1!);
    $pos = state.pos;
    $ch = state.ch;
    String? $2;
    state.ok = state.ch == 0x61 && state.source.startsWith('abc', state.pos);
    if (state.ok) {
      state.readChar(state.pos + 3);
      $2 = 'abc';
    } else {
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
  return $0;
}

Tuple2<int, int>? separatedPairC16AbcC32(State<String> state) {
  Tuple2<int, int>? $0;
  final $pos = state.pos;
  final $ch = state.ch;
  int? $1;
  state.ok = state.ch == 0x50;
  if (state.ok) {
    $1 = 0x50;
    state.nextChar();
  } else {
    state.error = ErrExpected.char(state.pos, const Char(0x50));
  }
  if (state.ok) {
    String? $2;
    state.ok = state.ch == 0x61 && state.source.startsWith('abc', state.pos);
    if (state.ok) {
      state.readChar(state.pos + 3);
      $2 = 'abc';
    } else {
      state.error = ErrExpected.tag(state.pos, const Tag('abc'));
    }
    if (state.ok) {
      int? $3;
      state.ok = state.ch == 0x1D200;
      if (state.ok) {
        $3 = 0x1D200;
        state.nextChar();
      } else {
        state.error = ErrExpected.char(state.pos, const Char(0x1D200));
      }
      if (state.ok) {
        $0 = Tuple2($1!, $3!);
      }
    }
  }
  if (!state.ok) {
    state.pos = $pos;
    state.ch = $ch;
  }
  return $0;
}

bool? skipC16C32(State<String> state) {
  bool? $0;
  final $pos = state.pos;
  final $ch = state.ch;
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
    state.ch = $ch;
  }
  return $0;
}

bool? skipMany0C16OrC32AndAbc(State<String> state) {
  bool? $0;
  for (;;) {
    final $pos = state.pos;
    final $ch = state.ch;
    dynamic $1;
    for (;;) {
      int? $2;
      $2 = char16(state);
      if (state.ok) {
        $1 = $2;
        break;
      }
      final $3 = state.error;
      int? $4;
      $4 = char32(state);
      if (state.ok) {
        $1 = $4;
        break;
      }
      final $5 = state.error;
      state.error = ErrCombined(state.pos, [$3, $5]);
      break;
    }
    if (state.ok) {
      String? $6;
      state.ok = state.ch == 0x61 && state.source.startsWith('abc', state.pos);
      if (state.ok) {
        state.readChar(state.pos + 3);
        $6 = 'abc';
      } else {
        state.error = ErrExpected.tag(state.pos, const Tag('abc'));
      }
      if (state.ok) {
        continue;
      }
    }

    state.pos = $pos;
    state.ch = $ch;
    state.ok = true;
    $0 = true;
    break;
  }
  return $0;
}

bool? skipWhile1IsC32(State<String> state) {
  bool? $0;
  var $c = state.ch;
  bool $test(int c) => c == 0x1d200;
  while ($c != State.eof && $test($c)) {
    $c = state.nextChar();
    $0 = true;
  }
  state.ok = $0 != null;
  if (!state.ok) {
    state.error = $c == State.eof
        ? ErrUnexpected.eof(state.pos)
        : ErrUnexpected.char(state.pos, Char($c));
  }
  return $0;
}

bool? skipWhileIsC32(State<String> state) {
  bool? $0;
  var $c = state.ch;
  bool $test(int c) => c == 0x1d200;
  while ($c != State.eof && $test($c)) {
    $c = state.nextChar();
  }
  state.ok = true;
  if (state.ok) {
    $0 = true;
  }
  return $0;
}

String? takeUntilAbc(State<String> state) {
  final source = state.source;
  String? $0;
  final $pos = state.pos;
  final $index = source.indexOf('abc', $pos);
  state.ok = $index != -1;
  if (state.ok) {
    state.readChar($index);
    $0 = source.substring($pos, $index);
  } else {
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
    state.readChar($index);
    $0 = source.substring($pos, $index);
  } else {
    state.error = ErrExpected.tag($pos, const Tag('abc'));
  }
  return $0;
}

String? takeWhile1C16(State<String> state) {
  String? $0;
  state.ok = false;
  final $pos = state.pos;
  var $c = state.ch;
  bool $test(int c) => c == 80;
  while ($c != State.eof && $test($c)) {
    $c = state.nextChar();
    state.ok = true;
  }
  if (state.ok) {
    $0 = state.source.substring($pos, state.pos);
  } else {
    state.error = $c == State.eof
        ? ErrUnexpected.eof(state.pos)
        : ErrUnexpected.char(state.pos, Char($c));
  }
  return $0;
}

String? takeWhile1C32(State<String> state) {
  String? $0;
  state.ok = false;
  final $pos = state.pos;
  var $c = state.ch;
  bool $test(int c) => c == 119296;
  while ($c != State.eof && $test($c)) {
    $c = state.nextChar();
    state.ok = true;
  }
  if (state.ok) {
    $0 = state.source.substring($pos, state.pos);
  } else {
    state.error = $c == State.eof
        ? ErrUnexpected.eof(state.pos)
        : ErrUnexpected.char(state.pos, Char($c));
  }
  return $0;
}

String? takeWhileC16(State<String> state) {
  String? $0;
  final $pos = state.pos;
  var $c = state.ch;
  bool $test(int c) => c == 80;
  while ($c != State.eof && $test($c)) {
    $c = state.nextChar();
  }
  state.ok = true;
  if (state.ok) {
    $0 = state.source.substring($pos, state.pos);
  }
  return $0;
}

String? takeWhileC16OrC32UntilAbc(State<String> state) {
  final source = state.source;
  String? $0;
  final $index = source.indexOf('abc', state.pos);
  if ($index != -1) {
    final pos = state.pos;
    final ch = state.ch;
    var c = ch;
    bool test(int c) => c == 80 || c == 119296;
    while (state.pos < $index) {
      if (c == State.eof || !test(c)) {
        break;
      }
      c = state.nextChar();
    }
    state.ok = state.pos == $index;
    if (state.ok) {
      $0 = source.substring(pos, state.pos);
    } else {
      state.error = ErrUnexpected.char(state.pos, Char(c));
      state.pos = pos;
      state.ch = ch;
    }
  } else {
    state.ok = false;
    state.error = ErrExpected.tag(state.pos, const Tag('abc'));
  }
  return $0;
}

String? takeWhileC32(State<String> state) {
  String? $0;
  final $pos = state.pos;
  var $c = state.ch;
  bool $test(int c) => c == 119296;
  while ($c != State.eof && $test($c)) {
    $c = state.nextChar();
  }
  state.ok = true;
  if (state.ok) {
    $0 = state.source.substring($pos, state.pos);
  }
  return $0;
}

String? takeWhileMN_2_4C16(State<String> state) {
  String? $0;
  final $pos = state.pos;
  final $ch = state.ch;
  var $c = $ch;
  var $cnt = 0;
  bool $test(int c) => c == 80;
  while ($cnt < 4) {
    if ($c == State.eof || !$test($c)) {
      break;
    }
    $c = state.nextChar();
    $cnt++;
  }
  state.ok = $cnt >= 2;
  if (state.ok) {
    $0 = state.source.substring($pos, state.pos);
  } else {
    state.error = $c == State.eof
        ? ErrUnexpected.eof(state.pos)
        : ErrUnexpected.char(state.pos, Char($c));
    state.pos = $pos;
    state.ch = $ch;
  }
  return $0;
}

String? takeWhileMN_2_4C32(State<String> state) {
  String? $0;
  final $pos = state.pos;
  final $ch = state.ch;
  var $c = $ch;
  var $cnt = 0;
  bool $test(int c) => c == 119296;
  while ($cnt < 4) {
    if ($c == State.eof || !$test($c)) {
      break;
    }
    $c = state.nextChar();
    $cnt++;
  }
  state.ok = $cnt >= 2;
  if (state.ok) {
    $0 = state.source.substring($pos, state.pos);
  } else {
    state.error = $c == State.eof
        ? ErrUnexpected.eof(state.pos)
        : ErrUnexpected.char(state.pos, Char($c));
    state.pos = $pos;
    state.ch = $ch;
  }
  return $0;
}

String? tagExFoo(State<String> state) {
  String? $0;
  String $get(dynamic x) => state.context.foo as String;
  final $tag = $get(null);
  state.ok = state.source.startsWith($tag, state.pos);
  if (state.ok) {
    state.readChar(state.pos + $tag.length);
    $0 = $tag;
  } else {
    state.error = ErrExpected.tag(state.pos, Tag($tag));
  }
  return $0;
}

String? tagNoCaseAbc(State<String> state) {
  final source = state.source;
  String? $0;
  state.ok = false;
  if (state.pos + 3 <= source.length) {
    String convert(String s) => s.toLowerCase();
    final v1 = source.substring(state.pos, state.pos + 3);
    final v2 = convert(v1);
    if (v2 == 'abc') {
      state.ok = true;
      state.readChar(state.pos + 3);
      $0 = v1;
    }
  }
  if (!state.ok) {
    state.error = ErrExpected.tag(state.pos, const Tag('abc'));
  }
  return $0;
}

String? tagsAbcAbdDefDegX(State<String> state) {
  final source = state.source;
  String? $0;
  switch (state.ch) {
    case 97:
      if (source.startsWith('abc', state.pos)) {
        state.readChar(state.pos + 3);
        $0 = 'abc';
        break;
      }
      if (source.startsWith('abd', state.pos)) {
        state.readChar(state.pos + 3);
        $0 = 'abd';
        break;
      }
      break;
    case 100:
      if (source.startsWith('def', state.pos)) {
        state.readChar(state.pos + 3);
        $0 = 'def';
        break;
      }
      if (source.startsWith('deg', state.pos)) {
        state.readChar(state.pos + 3);
        $0 = 'deg';
        break;
      }
      break;
    case 120:
      if (source.startsWith('x', state.pos)) {
        state.readChar(state.pos + 1);
        $0 = 'x';
        break;
      }
      break;
  }
  state.ok = $0 != null;
  if (!state.ok) {
    state.error = ErrCombined(state.pos, [
      ErrExpected.tag(state.pos, Tag('abc')),
      ErrExpected.tag(state.pos, Tag('abd')),
      ErrExpected.tag(state.pos, Tag('def')),
      ErrExpected.tag(state.pos, Tag('deg')),
      ErrExpected.tag(state.pos, Tag('x'))
    ]);
  }
  return $0;
}

String? tagC16(State<String> state) {
  String? $0;
  state.ok = state.ch == 0x50;
  if (state.ok) {
    state.nextChar();
    $0 = 'P';
  } else {
    state.error = ErrExpected.tag(state.pos, const Tag('P'));
  }
  return $0;
}

int? terminated(State<String> state) {
  int? $0;
  final $pos = state.pos;
  final $ch = state.ch;
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
    state.ch = $ch;
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
  final $ch = state.ch;
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
    state.ch = $ch;
  }
  return $0;
}

Tuple3<int, String, int>? tuple3C32AbcC16(State<String> state) {
  Tuple3<int, String, int>? $0;
  final $pos = state.pos;
  final $ch = state.ch;
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
    state.ch = $ch;
  }
  return $0;
}

bool? valueAbcToTrueValue(State<String> state) {
  bool? $0;
  String? $1;
  state.ok = state.ch == 0x61 && state.source.startsWith('abc', state.pos);
  if (state.ok) {
    state.readChar(state.pos + 3);
    $1 = 'abc';
  } else {
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
    final s = String.fromCharCode(charCode);
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
    var result = Err.flatten(error);
    result = Err.groupExpected(result);
    return result;
  }

  static List<Err> flatten(Err error) {
    void flatten(Err error, List<Err> result) {
      if (error is ErrCombined) {
        for (final error in error.errors) {
          flatten(error, result);
        }
      } else if (error is ErrWithTagAndErrors) {
        final inner = <Err>[];
        for (final nestedError in error.errors) {
          flatten(nestedError, inner);
        }

        int max(int x, int y) => x > y
            ? x
            : y < x
                ? x
                : y;
        final maxOffset = inner.map((e) => e.offset).reduce(max);
        final farthest = inner.where((e) => e.offset == maxOffset);
        final offset = error.offset;
        final tag = error.tag;
        result.add(ErrExpected.tag(offset, tag));
        if (maxOffset > offset) {
          if (error is ErrMalformed) {
            result
                .add(ErrMessage(offset, maxOffset - offset, 'Malformed $tag'));
            result.addAll(farthest);
          } else if (error is ErrNested) {
            result.addAll(farthest);
          } else {
            throw StateError('Internal error');
          }
        }
      } else {
        result.add(error);
      }
    }

    final result = <Err>[];
    flatten(error, result);
    return result.toSet().toList();
  }

  static List<Err> groupExpected(List<Err> errors) {
    final result = <Err>[];
    final expected = errors.whereType<ErrExpected>();
    Map<T, List<S>> groupBy<S, T>(Iterable<S> values, T Function(S) key) {
      final map = <T, List<S>>{};
      for (final element in values) {
        (map[key(element)] ??= []).add(element);
      }
      return map;
    }

    final groupped = groupBy(expected, (Err e) => e.offset);
    final offsets = <int>{};
    final processed = <Err>{};
    for (final error in errors) {
      if (!processed.add(error)) {
        continue;
      }

      if (error is! ErrExpected) {
        result.add(error);
        continue;
      }

      final offset = error.offset;
      if (!offsets.add(offset)) {
        continue;
      }

      final elements = <String>[];
      for (final error in groupped[offset]!) {
        elements.add(error.value.toString());
        processed.add(error);
      }

      final message = elements.join(', ');
      final newError = ErrMessage(offset, 1, 'Expected: $message');
      result.add(newError);
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

class ErrMalformed extends ErrWithTagAndErrors {
  @override
  final List<Err> errors;

  @override
  final int offset;

  @override
  final Tag tag;

  ErrMalformed(this.offset, this.tag, this.errors);

  @override
  int get length => 1;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return super == other && other is ErrMalformed;
  }

  @override
  String toString() {
    final result = 'Malformed $tag';
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

class ErrNested extends ErrWithTagAndErrors {
  @override
  final List<Err> errors;

  @override
  final int offset;

  @override
  final Tag tag;

  ErrNested(this.offset, this.tag, this.errors);

  @override
  int get length => 1;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return super == other && other is ErrNested;
  }

  @override
  String toString() {
    final result = 'Nested $tag';
    return result;
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

abstract class ErrWithTagAndErrors extends ErrWithErrors {
  Tag get tag;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return super == other && other is ErrWithTagAndErrors && other.tag == tag;
  }
}

class State<T> {
  static const eof = 0x110000;

  dynamic context;

  int ch = eof;

  Err error = ErrUnknown(0);

  bool ok = false;

  int pos = 0;

  final T source;

  State(this.source) {
    if (this is State<String>) {
      final this_ = this as State<String>;
      ch = this_.readChar(0);
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
    return name;
  }
}

extension on State<String> {
  @pragma('vm:prefer-inline')
  // ignore: unused_element
  int getChar(int index) {
    if (index < source.length) {
      final c = source.codeUnitAt(index);
      return c <= 0xD7FF || c >= 0xE000 ? c : _getChar32(c, index + 1);
    } else {
      return State.eof;
    }
  }

  @pragma('vm:prefer-inline')
  // ignore: unused_element
  int nextChar() {
    final index = pos + (ch > 0xffff ? 2 : 1);
    if (index < source.length) {
      pos = index;
      final c = source.codeUnitAt(index);
      ch = c <= 0xD7FF || c >= 0xE000 ? c : _getChar32(c, index + 1);
    } else {
      pos = source.length;
      ch = State.eof;
    }
    return ch;
  }

  @pragma('vm:prefer-inline')
  // ignore: unused_element
  int readChar(int index) {
    if (index < source.length) {
      pos = index;
      final c = source.codeUnitAt(index);
      ch = c <= 0xD7FF || c >= 0xE000 ? c : _getChar32(c, index + 1);
    } else {
      pos = source.length;
      ch = State.eof;
    }
    return ch;
  }

  @pragma('vm:prefer-inline')
  int _getChar32(int c, int index) {
    if (index < source.length) {
      final c2 = source.codeUnitAt(index);
      if ((c2 & 0xfc00) == 0xdc00) {
        return 0x10000 + ((c & 0x3ff) << 10) + (c2 & 0x3ff);
      }
    }
    return State.eof;
  }
}

extension on String {
  /// Returns `true` if [pos] points to the end of the string (or beyond).
  @pragma('vm:prefer-inline')
  // ignore: unused_element
  bool atEnd(int pos) {
    return pos >= length;
  }

  /// Returns a slice (substring) of the string from [start] to [end].
  @pragma('vm:prefer-inline')
  // ignore: unused_element
  String slice(int start, int end) {
    return substring(start, end);
  }
}
