// ignore_for_file: unused_local_variable

import 'package:source_span/source_span.dart';

void main() {
  final s = '100000.00123e3';
  final x = double.parse(s);
  print(s);
  print(x);
  final r = parse(s);
  print(r);
}

num? parse(String s) {
  final state = State(s);
  final r = number(state);
  if (!state.ok) {
    final errors = Err.errorReport(state.error);
    throw _errorMessage(state.source, errors);
  }
  return r!;
}

bool? _ws(State<String> state) {
  bool? $0;
  bool $test(int x) => x == 0x9 || x == 0xa || x == 0xd || x == 0x20;
  while (state.ch != State.eof && $test(state.ch)) {
    state.nextChar();
  }
  state.ok = true;
  if (state.ok) {
    $0 = true;
  }
  return $0;
}

num? number(State<String> state) {
  final source = state.source;
  num? $0;
  final $pos = state.pos;
  final $ch = state.ch;
  bool? $1;
  $1 = _ws(state);
  if (state.ok) {
    num? $2;
    final $pos1 = state.pos;
    final $ch1 = state.ch;
    num? $3;
    num? $4;
    for (;;) {
      //  '-'?('0'|[1-9][0-9]*)('.'[0-9]+)?([eE][+-]?[0-9]+)?
      const eof = 0x10ffff + 1;
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
      state.ok = true;
      final ch = state.ch;
      final length = source.length;
      final start = state.pos;
      var pos = state.pos;
      var c = eof;
      void error(int pos) {
        state.ok = false;
        state.ch = ch;
        if (pos < length) {
          final c = state.getChar(pos);
          state.error = ErrUnexpected.char(pos, Char(c));
        } else {
          state.error = ErrUnexpected.eof(pos);
        }
      }

      num parse() {
        state.ch = state.getChar(pos);
        return double.parse(source.substring(start, pos));
      }

      c = pos < length ? source.codeUnitAt(pos) : eof;
      var hasSign = false;
      if (c == 0x2d) {
        pos++;
        c = pos < length ? source.codeUnitAt(pos) : eof;
        hasSign = true;
      }
      var digit = c ^ mask;
      if (digit > 9) {
        error(pos);
        break;
      }
      final intPartPos = pos;
      var intPartLen = 0;
      intPartLen = 1;
      var intValue = 0;
      if (digit == 0) {
        pos++;
        c = pos < length ? source.codeUnitAt(pos) : eof;
      } else {
        pos++;
        c = pos < length ? source.codeUnitAt(pos) : eof;
        intValue = digit;
        while (true) {
          digit = c ^ mask;
          if (digit > 9) {
            break;
          }
          pos++;
          c = pos < length ? source.codeUnitAt(pos) : eof;
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
        c = pos < length ? source.codeUnitAt(pos) : eof;
        hasDot = true;
        digit = c ^ mask;
        if (digit > 9) {
          error(pos);
          break;
        }
        pos++;
        c = pos < length ? source.codeUnitAt(pos) : eof;
        decPartLen = 1;
        decValue = digit;
        while (true) {
          digit = c ^ mask;
          if (digit > 9) {
            break;
          }
          pos++;
          c = pos < length ? source.codeUnitAt(pos) : eof;
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
        c = pos < length ? source.codeUnitAt(pos) : eof;
        hasExp = true;
        switch (c) {
          case 0x2b:
            pos++;
            c = pos < length ? source.codeUnitAt(pos) : eof;
            break;
          case 0x2d:
            pos++;
            c = pos < length ? source.codeUnitAt(pos) : eof;
            hasExpSign = true;
            break;
        }
        digit = c ^ mask;
        if (digit > 9) {
          error(pos);
          break;
        }
        pos++;
        c = pos < length ? source.codeUnitAt(pos) : eof;
        expPartLen = 1;
        exp = digit;
        while (true) {
          digit = c ^ mask;
          if (digit > 9) {
            break;
          }
          pos++;
          c = pos < length ? source.codeUnitAt(pos) : eof;
          if (expPartLen++ < 18) {
            exp = exp * 10 + digit;
          }
        }
        if (expPartLen > 18) {
          $4 = parse();
          break;
        }
        if (hasExpSign) {
          exp = -exp;
        }
      }
      state.pos = pos;
      state.ch = state.getChar(pos);
      final singlePart = !hasDot && !hasExp;
      if (singlePart && intPartLen <= 18) {
        $4 = hasSign ? -intValue : intValue;
        break;
      }
      if (singlePart && intPartLen == 19) {
        if (intValue == 922337203685477580) {
          final digit = source.codeUnitAt(intPartPos + 18) - 0x30;
          if (digit <= 7) {
            intValue = intValue * 10 + digit;
            $4 = hasSign ? -intValue : intValue;
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
        $4 = parse();
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
      $4 = hasSign ? -doubleValue : doubleValue;
      state.ch = state.getChar(pos);
      break;
    }
    if (state.ok) {
      $3 = $4;
    } else {
      state.ok = false;
      state.error = ErrMalformed(state.pos, const Tag('number'), [state.error]);
    }
    if (state.ok) {
      bool? $5;
      $5 = _ws(state);
      if (state.ok) {
        $2 = $3!;
      }
    }
    if (!state.ok) {
      state.pos = $pos1;
      state.ch = $ch1;
    }
    if (state.ok) {
      bool? $6;
      state.ok = state.source.atEnd(state.pos);
      if (state.ok) {
        $6 = true;
      } else {
        state.error = ErrExpected.eof(state.pos);
      }
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
  int get length => 1;

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
  String toString() {
    final result = 'Unknown error';
    return result;
  }
}

abstract class ErrWithErrors extends Err {
  List<Err> get errors;

  @override
  String toString() {
    final list = errors.join(', ');
    final result = '[$list]';
    return result;
  }
}

abstract class ErrWithTagAndErrors extends ErrWithErrors {
  Tag get tag;
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
