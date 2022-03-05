import 'package:parser_builder/bytes.dart';
import 'package:parser_builder/combinator.dart';
import 'package:parser_builder/error.dart';
import 'package:parser_builder/fast_build.dart';
import 'package:parser_builder/parser_builder.dart';
import 'package:parser_builder/sequence.dart';

Future<void> main(List<String> args) async {
  final context = Context();
  final filename = 'test/_json_number_parser.dart';
  await fastBuild(context, [_parser], filename, header: __header);
}

const parser = Number();

const __header = '''
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
}''';

const _isWhitespace = ExprTransformer<int, bool>(
    'x', '{{x}} == 0x9 || {{x}} == 0xa || {{x}} == 0xd || {{x}} == 0x20');

const _number = Terminated(Malformed('number', parser), _ws);

const _parser = Named<String, num>('number', Delimited(_ws, _number, Eof()));

const _ws = Named('_ws', SkipWhile(_isWhitespace));

class Number extends StringParserBuilder<num> {
  static const _template = '''
    state.ok = true;
    final {{pos}} = state.pos;
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
      c = pos < length ? source.codeUnitAt(pos) : eof;
      var hasSign = false;
      if (c == 0x2d) {
        pos++;
        c = pos < length ? source.codeUnitAt(pos) : eof;
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
          state.ok = false;
          state.pos = pos;
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
          state.ok = false;
          state.pos = pos;
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
          state.pos = pos;
          {{res}} = double.parse(source.substring({{pos}}, pos));
          break;
        }
        if (hasExpSign) {
          exp = -exp;
        }
      }
      state.pos = pos;
      final singlePart = !hasDot && !hasExp;
      if (singlePart && intPartLen <= 18) {
        {{res}} = hasSign ? -intValue : intValue;
        break;
      }
      if (singlePart && intPartLen == 19) {
        if (intValue == 922337203685477580) {
          final digit = source.codeUnitAt(intPartPos + 18) - 0x30;
          if (digit <= 7) {
            intValue = intValue * 10 + digit;
            {{res}} = hasSign ? -intValue : intValue;
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
        {{res}} = double.parse(source.substring({{pos}}, pos));
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
      {{res}} = hasSign ? -doubleValue : doubleValue;
      break;
    }
    if (!state.ok) {
      if (state.pos < source.length) {
        var c = source.codeUnitAt(state.pos);
        c = c & 0xfc00 != 0xd800 ? c : source.runeAt(state.pos);
        state.error = ErrUnexpected.char(state.pos, Char(c));
      } else {
        state.error = ErrUnexpected.eof(state.pos);
      }
      state.pos = {{pos}};
    }''';

  const Number();

  @override
  Map<String, String> getTags(Context context) {
    return context.allocateLocals(['pos']);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
