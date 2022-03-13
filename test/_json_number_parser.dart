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
  final source = state.source;
  bool? $0;
  while (state.pos < source.length) {
    final pos = state.pos;
    final c = source.readRune(state);
    final ok = c == 0x9 || c == 0xa || c == 0xd || c == 0x20;
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

num? number(State<String> state) {
  final source = state.source;
  num? $0;
  final $pos = state.pos;
  bool? $1;
  $1 = _ws(state);
  if (state.ok) {
    num? $2;
    final $pos1 = state.pos;
    num? $3;
    state.ok = true;
    final $pos2 = state.pos;
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
          $3 = double.parse(source.substring($pos2, pos));
          break;
        }
        if (hasExpSign) {
          exp = -exp;
        }
      }
      state.pos = pos;
      final singlePart = !hasDot && !hasExp;
      if (singlePart && intPartLen <= 18) {
        $3 = hasSign ? -intValue : intValue;
        break;
      }
      if (singlePart && intPartLen == 19) {
        if (intValue == 922337203685477580) {
          final digit = source.codeUnitAt(intPartPos + 18) - 0x30;
          if (digit <= 7) {
            intValue = intValue * 10 + digit;
            $3 = hasSign ? -intValue : intValue;
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
        $3 = double.parse(source.substring($pos2, pos));
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
      $3 = hasSign ? -doubleValue : doubleValue;
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
      state.pos = $pos2;
    }
    if (state.ok) {
      bool? $4;
      $4 = _ws(state);
      if (state.ok) {
        $2 = $3!;
      }
    }
    if (!state.ok) {
      state.pos = $pos1;
    }
    if (state.ok) {
      bool? $5;
      state.ok = state.pos >= state.source.length;
      if (state.ok) {
        $5 = true;
      } else if (state.log) {
        state.error = ErrExpected.eof(state.pos);
      }
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
      for (final nested in error.errors) {
        _flatten(nested, inner);
      }

      final farthest = inner.map((e) => e.offset).reduce(_max);
      inner.removeWhere((e) => e.offset < farthest);
      final offset = error.offset;
      final tag = error.tag;
      if (tag != null) {
        result.add(ErrExpected.tag(offset, tag));
      }

      if (farthest > offset) {
        result.add(_ErrInner(farthest, offset, error.message));
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

  static List<Err> _postprocess(List<Err> errors) {
    var result = errors.toList();
    final farthest =
        result.isEmpty ? -1 : result.map((e) => e.offset).reduce(_max);
    result.removeWhere((e) => e.offset < farthest);
    final expected =
        result.whereType<ErrExpected>().map((e) => '${e.value}').toList();
    if (expected.isNotEmpty) {
      expected.sort();
      result.removeWhere((e) => e is ErrExpected);
      result.add(ErrMessage(farthest, 1, 'Expected: ${expected.join(', ')}'));
    }

    for (var i = 0; i < result.length; i++) {
      final error = result[i];
      if (error is _ErrInner) {
        final length = error.offset;
        error.offset = error.length;
        error.length = length;
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

  final Tag? tag;

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

abstract class ErrWithTagAndErrors extends ErrWithErrors {
  Tag get tag;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return super == other && other is ErrWithTagAndErrors && other.tag == tag;
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

class _ErrInner extends Err {
  @override
  int length;

  String message;

  @override
  int offset;

  _ErrInner(this.offset, this.length, this.message);

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return super == other && other is _ErrInner && other.message == message;
  }

  @override
  String toString() {
    return message;
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
