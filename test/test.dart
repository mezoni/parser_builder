// ignore_for_file: unnecessary_string_interpolations

import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

import '_test_parser.dart';

void main(List<String> args) {
  _test();
}

const abc = 'abc';

const c16 = 0x50;

const c32 = 0x1d200;

const s16 = 'P';

const s32 = '𝈀';

void _test() {
  _testAlpha0();
  _testAlpha1();
  _testAlphanumeric0();
  _testAlphanumeric1();
  _testAlt();
  _testAnd();
  _testAnyChar();
  _testBinaryExpression();
  _testChar();
  _testConsumed();
  _testDelimited();
  _testDigit0();
  _testDigit1();
  _testEof();
  _testEscapeSequence();
  // EscapedTransform
  _testFoldMany0();
  _testHexDigit0();
  _testHexDigit1();
  _testMany0();
  _testMany0Count();
  _testMany1();
  _testMany1Count();
  _testManyMN();
  _testManyN();
  _testManyTill();
  _testMap();
  _testMap1();
  _testNoneOf();
  _testNoneOfEx();
  _testNoneOfTags();
  _testNot();
  _testOneOf();
  _testOpt();
  _testPair();
  _testPeek();
  _testPreceded();
  _testRecognize();
  _testRef();
  _testSatisfy();
  _testSeparatedPair();
  _testSeparatedList0();
  _testSeparatedList1();
  _testSkipWhile();
  _testSkipWhile1();
  _testStringValue();
  _testTag();
  _testTagOf();
  _testTagNoCase();
  _testTags();
  _testTakeUntil();
  _testTakeUntil1();
  _testTakeWhile();
  _testTakeWhile1();
  _testTakeWhileMN();
  _testTerminated();
  _testTuple();
  _testValue();
  _testSemanticActions();
  _testVerify();
}

void _testAlpha0() {
  test('Alpha0', () {
    final parser = alpha0;
    {
      final state = State('a');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'a');
      expect(state.pos, 1);
    }
    {
      final state = State('az');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'az');
      expect(state.pos, 2);
    }
    {
      final state = State('az1');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'az');
      expect(state.pos, 2);
    }
    {
      final state = State('A');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'A');
      expect(state.pos, 1);
    }
    {
      final state = State('AZ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'AZ');
      expect(state.pos, 2);
    }
    {
      final state = State('AZ1');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'AZ');
      expect(state.pos, 2);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '');
      expect(state.pos, 0);
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '');
      expect(state.pos, 0);
    }
  });
}

void _testAlpha1() {
  test('Alpha1', () {
    final parser = alpha1;
    {
      final state = State('a');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'a');
      expect(state.pos, 1);
    }
    {
      final state = State('az');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'az');
      expect(state.pos, 2);
    }
    {
      final state = State('az1');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'az');
      expect(state.pos, 2);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.eof(0));
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(c32)));
    }
  });
}

void _testAlphanumeric0() {
  test('Alphanumeric0', () {
    final parser = alphanumeric0;
    {
      final state = State('a');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'a');
      expect(state.pos, 1);
    }
    {
      final state = State('az');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'az');
      expect(state.pos, 2);
    }
    {
      final state = State('1');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '1');
      expect(state.pos, 1);
    }
    {
      final state = State('19');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '19');
      expect(state.pos, 2);
    }
    {
      final state = State('az19');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'az19');
      expect(state.pos, 4);
    }
    {
      final state = State('A');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'A');
      expect(state.pos, 1);
    }
    {
      final state = State('AZ');
      final r = parser(state);
      expect(r, 'AZ');
      expect(state.ok, true);
      expect(state.pos, 2);
    }
    {
      final state = State('AZ19');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'AZ19');
      expect(state.pos, 4);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '');
      expect(state.pos, 0);
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '');
      expect(state.pos, 0);
    }
  });
}

void _testAlphanumeric1() {
  test('Alphanumeric1', () {
    final parser = alphanumeric1;
    {
      final state = State('a');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'a');
      expect(state.pos, 1);
    }
    {
      final state = State('az');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'az');
      expect(state.pos, 2);
    }
    {
      final state = State('1');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '1');
      expect(state.pos, 1);
    }
    {
      final state = State('19');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '19');
      expect(state.pos, 2);
    }
    {
      final state = State('az19');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'az19');
      expect(state.pos, 4);
    }
    {
      final state = State('A');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'A');
      expect(state.pos, 1);
    }
    {
      final state = State('AZ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'AZ');
      expect(state.pos, 2);
    }
    {
      final state = State('AZ19');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'AZ19');
      expect(state.pos, 4);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.eof(0));
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(c32)));
    }
  });
}

void _testAlt() {
  test('Alt', () {
    final parser = altC16OrC32;
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, c16);
      expect(state.pos, 1);
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, c32);
      expect(state.pos, 2);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, isA<ErrCombined>());
      expect(
          state.error,
          ErrCombined(0, [
            ErrExpected.char(0, Char(c16)),
            ErrExpected.char(0, Char(c32))
          ]));
    }
    {
      final state = State(' $s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, isA<ErrCombined>());
      expect(
          state.error,
          ErrCombined(0, [
            ErrExpected.char(0, Char(c16)),
            ErrExpected.char(0, Char(c32))
          ]));
    }
  });
}

void _testAnd() {
  test('And', () {
    final parser = andC32OrC16;
    {
      final state = State('$s32');
      parser(state);
      expect(state.ok, true);
      expect(state.pos, 0);
    }
    {
      final state = State('$s16');
      parser(state);
      expect(state.ok, true);
      expect(state.pos, 0);
    }
    {
      final state = State('');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.error, ErrUnknown(0));
    }
    {
      final state = State(' ');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.error, ErrUnknown(0));
    }
  });
}

void _testAnyChar() {
  test('AnyChar', () {
    final parser = anyChar;
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, c16);
      expect(state.pos, 1);
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, c32);
      expect(state.pos, 2);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.eof(0));
    }
  });
}

void _testBinaryExpression() {
  test('BinaryExpression', () {
    final parser = binaryExpressionAdd;
    {
      final state = State('1');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 1);
      expect(state.pos, 1);
    }
    {
      final state = State('1+2');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 3);
      expect(state.pos, 3);
    }
    {
      final state = State('1+2*3');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 7);
      expect(state.pos, 5);
    }
    {
      final state = State('1+2*3+4');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 11);
      expect(state.pos, 7);
    }
    {
      final state = State('1*2-3');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, -1);
      expect(state.pos, 5);
    }
  });
}

void _testChar() {
  test('Char', () {
    for (var i = 0; i < 2; i++) {
      final parser = i == 0 ? char16 : char32;
      final c = i == 0 ? c16 : c32;
      final s = i == 0 ? s16 : s32;
      final len = i == 0 ? 1 : 2;
      {
        final state = State('$s');
        final r = parser(state);
        expect(state.ok, true);
        expect(r, c);
        expect(state.pos, 1 * len);
      }
      {
        final state = State('$s ');
        final r = parser(state);
        expect(state.ok, true);
        expect(r, c);
        expect(state.pos, 1 * len);
      }
      {
        final state = State(' $s');
        final r = parser(state);
        expect(state.ok, false);
        expect(r, null);
        expect(state.pos, 0);
        expect(state.error, ErrExpected.char(0, Char(c)));
      }
      {
        final state = State('');
        final r = parser(state);
        expect(state.ok, false);
        expect(r, null);
        expect(state.pos, 0);
        expect(state.error, ErrExpected.char(0, Char(c)));
      }
    }
  });
}

void _testConsumed() {
  test('Consumed', () {
    final parser = consumedSeparatedAbcC32;
    {
      final state = State('$abc$s32$abc');
      final r = parser(state);
      expect(state.ok, true);
      final v = r!;
      expect(v.item1, '$abc$s32$abc');
      expect(v.item2, [abc, abc]);
      expect(state.pos, 8);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(0, Tag(abc)));
    }
  });
}

void _testDelimited() {
  test('Delimited', () {
    final parser = delimited;
    {
      final state = State('$s16$s32$s16');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, c32);
      expect(state.pos, 4);
    }
    {
      final state = State('$s32$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c16)));
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c16)));
    }
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(1, Char(c32)));
    }
  });
}

void _testDigit0() {
  test('Digit0', () {
    final parser = digit0;
    {
      final state = State('1');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '1');
      expect(state.pos, 1);
    }
    {
      final state = State('19');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '19');
      expect(state.pos, 2);
    }
    {
      final state = State('19a');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '19');
      expect(state.pos, 2);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '');
      expect(state.pos, 0);
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '');
      expect(state.pos, 0);
    }
  });
}

void _testDigit1() {
  test('Digit1', () {
    final parser = digit1;
    {
      final state = State('1');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '1');
      expect(state.pos, 1);
    }
    {
      final state = State('19');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '19');
      expect(state.pos, 2);
    }
    {
      final state = State('19a');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '19');
      expect(state.pos, 2);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.eof(0));
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(c32)));
    }
  });
}

void _testEof() {
  test('Eof', () {
    final parser = eof;
    {
      final state = State('');
      parser(state);
      expect(state.ok, true);
      expect(state.pos, 0);
    }
    {
      final state = State(' ');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.eof(0));
    }
  });
}

void _testEscapeSequence() {
  test('EscapeSequence', () {
    final parser16 = escapeSequence16;
    {
      final state = State('n');
      final r = parser16(state);
      expect(state.ok, true);
      expect(r, 0xa);
      expect(state.pos, 1);
    }
    {
      final state = State('r');
      final r = parser16(state);
      expect(state.ok, true);
      expect(r, 0xd);
      expect(state.pos, 1);
    }
    {
      final state = State('$s16');
      final r = parser16(state);
      expect(state.ok, true);
      expect(r, c16);
      expect(state.pos, 1);
    }
    {
      final state = State('');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.eof(0));
    }
    {
      final state = State(' ');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(0x20)));
    }
    {
      final state = State('$s32');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(c32)));
    }
    final parser32 = escapeSequence32;
    {
      final state = State('n');
      final r = parser32(state);
      expect(state.ok, true);
      expect(r, 0xa);
      expect(state.pos, 1);
    }
    {
      final state = State('r');
      final r = parser32(state);
      expect(state.ok, true);
      expect(r, 0xd);
      expect(state.pos, 1);
    }
    {
      final state = State('$s16');
      final r = parser32(state);
      expect(state.ok, true);
      expect(r, c16);
      expect(state.pos, 1);
    }
    {
      final state = State('$s32');
      final r = parser32(state);
      expect(state.ok, true);
      expect(r, c32);
      expect(state.pos, 2);
    }
    {
      final state = State('');
      final r = parser32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.eof(0));
    }
    {
      final state = State(' ');
      final r = parser32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(0x20)));
    }
  });
}

void _testFoldMany0() {
  test('Many0Fold', () {
    final parser = foldMany0Digit;
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 0);
      expect(state.pos, 0);
    }
    {
      final state = State('1');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 1);
      expect(state.pos, 1);
    }
    {
      final state = State('12');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 12);
      expect(state.pos, 2);
    }
    {
      final state = State('123');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 123);
      expect(state.pos, 3);
    }
    {
      final state = State(' ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 0);
      expect(state.pos, 0);
    }
  });
}

void _testHexDigit0() {
  test('hexDigit0', () {
    final parser = hexDigit0;
    {
      final state = State('0123456789abcdefABCDEF');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '0123456789abcdefABCDEF');
      expect(state.pos, 22);
    }
    {
      final state = State('0123456789abcdefABCDEFX');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '0123456789abcdefABCDEF');
      expect(state.pos, 22);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '');
      expect(state.pos, 0);
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '');
      expect(state.pos, 0);
    }
  });
}

void _testHexDigit1() {
  test('hexDigit1', () {
    final parser = hexDigit1;
    {
      final state = State('0123456789abcdefABCDEF');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '0123456789abcdefABCDEF');
      expect(state.pos, 22);
    }
    {
      final state = State('0123456789abcdefABCDEFX');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '0123456789abcdefABCDEF');
      expect(state.pos, 22);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.eof(0));
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(c32)));
    }
  });
}

void _testMany0() {
  test('Many0', () {
    final parser16 = many0C16;
    {
      final state = State('');
      final r = parser16(state);
      expect(state.ok, true);
      expect(r, <int>[]);
      expect(state.pos, 0);
    }
    {
      final state = State('$s16');
      final r = parser16(state);
      expect(state.ok, true);
      expect(r, [c16]);
      expect(state.pos, 1);
    }
    {
      final state = State('$s16$s16$s16');
      final r = parser16(state);
      expect(state.ok, true);
      expect(r, [c16, c16, c16]);
      expect(state.pos, 3);
    }
    {
      final state = State('$s32');
      final r = parser16(state);
      expect(state.ok, true);
      expect(r, <int>[]);
      expect(state.pos, 0);
    }

    final parser32 = many0C32;
    {
      final state = State('');
      final r = parser32(state);
      expect(state.ok, true);
      expect(r, <int>[]);
      expect(state.pos, 0);
    }
    {
      final state = State('$s32');
      final r = parser32(state);
      expect(state.ok, true);
      expect(r, [c32]);
      expect(state.pos, 2);
    }
    {
      final state = State('$s32$s32$s32');
      final r = parser32(state);
      expect(state.ok, true);
      expect(r, [c32, c32, c32]);
      expect(state.pos, 6);
    }
    {
      final state = State('$s16');
      final r = parser32(state);
      expect(state.ok, true);
      expect(r, <int>[]);
      expect(state.pos, 0);
    }
  });
}

void _testMany0Count() {
  test('Many0Count', () {
    final parser = many0CountC32;
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 0);
      expect(state.pos, 0);
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(r, 1);
      expect(state.ok, true);
      expect(state.pos, 2);
    }
    {
      final state = State('$s32$s32$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 3);
      expect(state.pos, 6);
    }
    {
      final state = State('$s16');
      final r = parser(state);
      expect(r, 0);
      expect(state.ok, true);
      expect(state.pos, 0);
    }
  });
}

void _testMany1() {
  test('Many1', () {
    final parser = many1C32;
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c32)));
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [c32]);
      expect(state.pos, 2);
    }
    {
      final state = State('$s32$s32$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [c32, c32, c32]);
      expect(state.pos, 6);
    }
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c32)));
    }
  });
}

void _testMany1Count() {
  test('Many1Count', () {
    final parser = many1CountC32;
    {
      final state = State('');
      final r = parser(state);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c32)));
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 1);
      expect(state.pos, 2);
    }
    {
      final state = State('$s32$s32$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 3);
      expect(state.pos, 6);
    }
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c32)));
    }
  });
}

void _testManyMN() {
  test('ManyMN', () {
    final parser2_3 = manyMNC32_2_3;
    {
      final state = State('');
      final r = parser2_3(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c32)));
    }
    {
      final state = State('$s32');
      final r = parser2_3(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(2, Char(c32)));
    }
    {
      final state = State('$s32$s32');
      final r = parser2_3(state);
      expect(state.ok, true);
      expect(r, [c32, c32]);
      expect(state.pos, 4);
    }
    {
      final state = State('$s32$s32$s32');
      final r = parser2_3(state);
      expect(state.ok, true);
      expect(r, [c32, c32, c32]);
      expect(state.pos, 6);
    }
    {
      final state = State('$s32$s32$s32$s32');
      final r = parser2_3(state);
      expect(state.ok, true);
      expect(r, [c32, c32, c32]);
      expect(state.pos, 6);
    }
    {
      final state = State('$s16');
      final r = parser2_3(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c32)));
    }
  });
}

void _testManyN() {
  test('ManyN', () {
    final parser2 = manyNC32_2;
    {
      final state = State('');
      final r = parser2(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c32)));
    }
    {
      final state = State('$s32');
      final r = parser2(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(2, Char(c32)));
    }
    {
      final state = State('$s32$s32');
      final r = parser2(state);
      expect(state.ok, true);
      expect(r, [c32, c32]);
      expect(state.pos, 4);
    }
    {
      final state = State('$s32$s32$s32');
      final r = parser2(state);
      expect(state.ok, true);
      expect(r, [c32, c32]);
      expect(state.pos, 4);
    }
    {
      final state = State('$s16');
      final r = parser2(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c32)));
    }
  });
}

void _testManyTill() {
  test('ManyTill', () {
    final parser = manyTillAOrBTillAbc;
    {
      final state = State('$abc');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, isA<Tuple2<List<String>, String>>());
      expect(r!.item1, <String>[]);
      expect(r.item2, 'abc');
      expect(state.pos, 3);
    }
    {
      final state = State('a$abc');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, isA<Tuple2<List<String>, String>>());
      expect(r!.item1, ['a']);
      expect(r.item2, 'abc');
      expect(state.pos, 4);
    }
    {
      final state = State('ab$abc');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, isA<Tuple2<List<String>, String>>());
      expect(r!.item1, ['a', 'b']);
      expect(r.item2, 'abc');
      expect(state.pos, 5);
    }
    {
      final state = State(' $abc');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(
          state.error,
          ErrCombined(0, [
            ErrExpected.tag(0, Tag('abc')),
            ErrCombined(
                0, [ErrExpected.tag(0, Tag('a')), ErrExpected.tag(0, Tag('b'))])
          ]));
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(
          state.error,
          ErrCombined(0, [
            ErrExpected.tag(0, Tag('abc')),
            ErrCombined(
                0, [ErrExpected.tag(0, Tag('a')), ErrExpected.tag(0, Tag('b'))])
          ]));
    }
    {
      final state = State('a');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(
          state.error,
          ErrCombined(1, [
            ErrExpected.tag(1, Tag('abc')),
            ErrCombined(
                1, [ErrExpected.tag(1, Tag('a')), ErrExpected.tag(1, Tag('b'))])
          ]));
    }
  });
}

void _testMap() {
  test('Map4', () {
    final parser = map4Digits;
    {
      final state = State('1234');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 1234);
      expect(state.pos, 4);
    }
    {
      final state = State('123$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(3, Char(c16)));
    }
    {
      final state = State('123');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.eof(3));
    }
    {
      final state = State(' ');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(0x20)));
    }
  });
}

void _testMap1() {
  test('Map\$', () {
    final parser = mapC32ToStr;
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, s32);
      expect(state.pos, 2);
    }
    {
      final state = State(' ');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c32)));
    }
  });
}

void _testNoneOf() {
  test('NoneOf', () {
    final parser16 = noneOfC16;
    {
      final state = State('a');
      final r = parser16(state);
      expect(state.ok, true);
      expect(r, 0x61);
      expect(state.pos, 1);
    }
    {
      final state = State('$s32');
      final r = parser16(state);
      expect(state.ok, true);
      expect(r, c32);
      expect(state.pos, 2);
    }
    {
      final state = State('$s16');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(c16)));
    }
    {
      final state = State('');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.eof(0));
    }

    final parser32 = noneOfC32;
    {
      final state = State('a');
      final r = parser32(state);
      expect(state.ok, true);
      expect(r, 0x61);
      expect(state.pos, 1);
    }
    {
      final state = State('$s16');
      final r = parser32(state);
      expect(state.ok, true);
      expect(r, c16);
      expect(state.pos, 1);
    }
    {
      final state = State('$s32');
      final r = parser32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(c32)));
    }
    {
      final state = State('');
      final r = parser32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.eof(0));
    }
  });
}

void _testNoneOfEx() {
  test('NoneOfOf', () {
    final parser1 = noneOfOfC16OrC32;
    {
      final state = State('a');
      state.context = _StateContext();
      final r = parser1(state);
      expect(state.ok, true);
      expect(r, 0x61);
      expect(state.pos, 1);
    }
    {
      final state = State(' ');
      state.context = _StateContext();
      final r = parser1(state);
      expect(state.ok, true);
      expect(r, 0x20);
      expect(state.pos, 1);
    }
    {
      final state = State('');
      state.context = _StateContext();
      final r = parser1(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.eof(0));
    }
    {
      final state = State('$s16');
      state.context = _StateContext();
      final r = parser1(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(c16)));
    }
    {
      final state = State('$s32');
      state.context = _StateContext();
      final r = parser1(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(c32)));
    }
  });
}

void _testNoneOfTags() {
  test('NoneOfTags', () {
    final parser = noneOfTagsAbcAbdDefDegXXY;
    {
      final state = State('abc');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.tag(0, Tag('abc')));
    }
    {
      final state = State('abd');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.tag(0, Tag('abd')));
    }
    {
      final state = State('def');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.tag(0, Tag('def')));
    }
    {
      final state = State('deg');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.tag(0, Tag('deg')));
    }
    {
      final state = State('x');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.tag(0, Tag('x')));
    }
    {
      final state = State('xy');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.tag(0, Tag('xy')));
    }
    {
      final state = State('');
      parser(state);
      expect(state.ok, true);
      expect(state.pos, 0);
    }
    {
      final state = State('abx');
      parser(state);
      expect(state.ok, true);
      expect(state.pos, 0);
    }
  });
}

void _testNot() {
  test('Not', () {
    final parser = notC32OrC16;
    {
      final state = State('$abc');
      parser(state);
      expect(state.ok, true);
      expect(state.pos, 0);
    }
    {
      final state = State('');
      parser(state);
      expect(state.ok, true);
      expect(state.pos, 0);
    }
    {
      final state = State('$s16');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.error, ErrUnknown(0));
    }
    {
      final state = State('$s32');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.error, ErrUnknown(0));
    }
  });
}

void _testOneOf() {
  test('OneOf', () {
    final parser16 = oneOfC16;
    {
      final state = State('$s16');
      final r = parser16(state);
      expect(state.ok, true);
      expect(r, c16);
      expect(state.pos, 1);
    }
    {
      final state = State('$s32');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(c32)));
    }
    {
      final state = State('a');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(0x61)));
    }
    {
      final state = State('');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.eof(0));
    }

    final parser32 = oneOfC32;
    {
      final state = State('$s32');
      final r = parser32(state);
      expect(state.ok, true);
      expect(r, c32);
      expect(state.pos, 2);
    }
    {
      final state = State('$s16');
      final r = parser32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(c16)));
    }
    {
      final state = State('a');
      final r = parser32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(0x61)));
    }
    {
      final state = State('');
      final r = parser32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.eof(0));
    }
  });
}

void _testOpt() {
  test('Opt', () {
    final parser = optAbc;
    {
      final state = State(abc);
      final r = parser(state);
      expect(state.ok, true);
      expect(r, abc);
      expect(state.pos, 3);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, null);
      expect(state.pos, 0);
    }
    {
      final state = State(' ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, null);
      expect(state.pos, 0);
    }
  });
}

void _testPair() {
  test('Pair', () {
    final parser = pairC16C32;
    {
      final state = State('$s16$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, Tuple2(c16, c32));
      expect(state.pos, 3);
    }
    {
      final state = State('$s32$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c16)));
    }
  });
}

void _testPeek() {
  test('Peek', () {
    final parser = peekC32;
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, c32);
      expect(state.pos, 0);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c32)));
    }
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c32)));
    }
  });
}

void _testPreceded() {
  test('Preceded', () {
    final parser = precededC16C32;
    {
      final state = State('$s16$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, c32);
      expect(state.pos, 3);
    }
    {
      final state = State('$s32$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c16)));
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c16)));
    }
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(1, Char(c32)));
    }
  });
}

void _testRecognize() {
  test('Recognize', () {
    final parser = recognize3C32AbcC16;
    {
      final state = State('$s32$abc$s16');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '$s32$abc$s16');
      expect(state.pos, 6);
    }
    {
      final state = State('$s32$abc$s16');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '$s32$abc$s16');
      expect(state.pos, 6);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c32)));
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(2, Tag(abc)));
    }
    {
      final state = State('$s32$abc');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(5, Char(c16)));
    }
  });
}

void _testRef() {
  test('Ref', () {
    final parser = testRef;
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, c16);
      expect(state.pos, 1);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c16)));
    }
  });
}

void _testSatisfy() {
  test('Satisfy', () {
    final parser16 = satisfyC16;
    {
      final state = State('$s16');
      final r = parser16(state);
      expect(state.ok, true);
      expect(r, c16);
      expect(state.pos, 1);
    }
    {
      final state = State('$s16$s16');
      final r = parser16(state);
      expect(state.ok, true);
      expect(r, c16);
      expect(state.pos, 1);
    }
    {
      final state = State('');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.eof(0));
    }
    {
      final state = State('$s32');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(c32)));
    }

    final parser32 = satisfyC32;
    {
      final state = State('$s32');
      final r = parser32(state);
      expect(state.ok, true);
      expect(r, c32);
      expect(state.pos, 2);
    }
    {
      final state = State('$s32$s32');
      final r = parser32(state);
      expect(state.ok, true);
      expect(r, c32);
      expect(state.pos, 2);
    }
    {
      final state = State('');
      final r = parser32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.eof(0));
    }
    {
      final state = State('$s16');
      final r = parser32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(c16)));
    }
  });
}

void _testSemanticActions() {
  final parsers = {
    'CharClass': transformersCharClassIsDigit,
    'ExpressionAction': transformersExprIsDigit,
    'FunctionAction': transformersFuncIsDigit,
    'NotCharClass': transformersNotCharClassIsDigit,
  };
  for (final key in parsers.keys) {
    test('Semantic action $key', () {
      final parser = parsers[key]!;
      {
        final state = State('123');
        final r = parser(state);
        expect(state.ok, true);
        expect(r, '123');
        expect(state.pos, 3);
      }
      {
        final state = State('123 ');
        final r = parser(state);
        expect(state.ok, true);
        expect(r, '123');
        expect(state.pos, 3);
      }
      {
        final state = State('');
        final r = parser(state);
        expect(state.ok, true);
        expect(r, '');
        expect(state.pos, 0);
      }
      {
        final state = State(' ');
        final r = parser(state);
        expect(state.ok, true);
        expect(r, '');
        expect(state.pos, 0);
      }
    });

    test('Semantic action VariableAction', () {
      final parser = transformersVarIsNotDigit;
      {
        final state = State('a');
        final r = parser(state);
        expect(state.ok, true);
        expect(r, 0x61);
        expect(state.pos, 1);
      }
      {
        final state = State('');
        final r = parser(state);
        expect(state.ok, false);
        expect(r, null);
        expect(state.pos, 0);
        expect(state.error, ErrUnexpected.eof(0));
      }
      {
        final state = State('1');
        final r = parser(state);
        expect(state.ok, false);
        expect(r, null);
        expect(state.pos, 0);
        expect(state.error, ErrUnexpected.char(0, Char(0x31)));
      }
    });
  }
}

void _testSeparatedList0() {
  test('SeparatedList0', () {
    final parser = separatedList0C32Abc;
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [c32]);
      expect(state.pos, 2);
    }
    {
      final state = State('$s32$abc');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [c32]);
      expect(state.pos, 2);
    }
    {
      final state = State('$s32$abc$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [c32, c32]);
      expect(state.pos, 7);
    }
    {
      final state = State('$s32$abc$s32$abc');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [c32, c32]);
      expect(state.pos, 7);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, <int>[]);
      expect(state.pos, 0);
    }
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, <int>[]);
      expect(state.pos, 0);
    }
  });
}

void _testSeparatedList1() {
  test('SeparatedList1', () {
    final parser = separatedList1C32Abc;
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [c32]);
      expect(state.pos, 2);
    }
    {
      final state = State('$s32$abc');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [c32]);
      expect(state.pos, 2);
    }
    {
      final state = State('$s32$abc$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [c32, c32]);
      expect(state.pos, 7);
    }
    {
      final state = State('$s32$abc$s32$abc');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [c32, c32]);
      expect(state.pos, 7);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c32)));
    }
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c32)));
    }
  });
}

void _testSeparatedPair() {
  test('SeparatedPair', () {
    final parser = separatedPairC16AbcC32;
    {
      final state = State('$s16$abc$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, Tuple2(c16, c32));
      expect(state.pos, 6);
    }
    {
      final state = State('$s16$abc');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(4, Char(c32)));
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c16)));
    }
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(1, Tag(abc)));
    }
  });
}

void _testSkipWhile() {
  test('SkipWhile', () {
    final parser16 = skipWhileC16;
    {
      final state = State('$s16');
      parser16(state);
      expect(state.ok, true);
      expect(state.pos, 1);
    }
    {
      final state = State('$s16$s16');
      parser16(state);
      expect(state.ok, true);
      expect(state.pos, 2);
    }
    {
      final state = State('$s16$s16 ');
      parser16(state);
      expect(state.ok, true);
      expect(state.pos, 2);
    }
    {
      final state = State('');
      parser16(state);
      expect(state.ok, true);
      expect(state.pos, 0);
    }
    {
      final state = State(' ');
      parser16(state);
      expect(state.ok, true);
      expect(state.pos, 0);
    }
    final parser32 = skipWhileC32;
    {
      final state = State('$s32');
      parser32(state);
      expect(state.ok, true);
      expect(state.pos, 2);
    }
    {
      final state = State('$s32$s32');
      parser32(state);
      expect(state.ok, true);
      expect(state.pos, 4);
    }
    {
      final state = State('$s32$s32 ');
      parser32(state);
      expect(state.ok, true);
      expect(state.pos, 4);
    }
    {
      final state = State('');
      parser32(state);
      expect(state.ok, true);
      expect(state.pos, 0);
    }
    {
      final state = State(' ');
      parser32(state);
      expect(state.ok, true);
      expect(state.pos, 0);
    }
  });
}

void _testSkipWhile1() {
  test('SkipWhile1', () {
    final parser16 = skipWhile1C16;
    {
      final state = State('$s16');
      parser16(state);
      expect(state.ok, true);
      expect(state.pos, 1);
    }
    {
      final state = State('$s16$s16');
      parser16(state);
      expect(state.ok, true);
      expect(state.pos, 2);
    }
    {
      final state = State('$s16$s16 ');
      parser16(state);
      expect(state.ok, true);
      expect(state.pos, 2);
    }
    {
      final state = State('');
      parser16(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.eof(0));
    }
    {
      final state = State('$s32');
      parser16(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(c32)));
    }
    final parser32 = skipWhile1C32;
    {
      final state = State('$s32');
      parser32(state);
      expect(state.ok, true);
      expect(state.pos, 2);
    }
    {
      final state = State('$s32$s32');
      parser32(state);
      expect(state.ok, true);
      expect(state.pos, 4);
    }
    {
      final state = State('$s32$s32 ');
      parser32(state);
      expect(state.ok, true);
      expect(state.pos, 4);
    }
    {
      final state = State('');
      parser32(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.eof(0));
    }
    {
      final state = State('$s16');
      parser32(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.char(0, Char(c16)));
    }
  });
}

void _testStringValue() {
  test('StringValue', () {
    final parser = stringValue;
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '');
      expect(state.pos, 0);
    }
    {
      final state = State(' ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, ' ');
      expect(state.pos, 1);
    }
    {
      final state = State(r' \n');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, ' \n');
      expect(state.pos, 3);
    }
    {
      final state = State(r' \n\n');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, ' \n\n');
      expect(state.pos, 5);
    }
    {
      final state = State(r' \n\n ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, ' \n\n ');
      expect(state.pos, 6);
    }
    {
      final state = State(r'\n');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '\n');
      expect(state.pos, 2);
    }
    {
      final state = State(r'\n ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '\n ');
      expect(state.pos, 3);
    }
    {
      final state = State(r'\n\n ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '\n\n ');
      expect(state.pos, 5);
    }
    {
      final state = State(r'\n \n');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '\n \n');
      expect(state.pos, 5);
    }
    {
      final state = State(r' \n ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, ' \n ');
      expect(state.pos, 4);
    }
  });
}

void _testTag() {
  test('Tag', () {
    final parser16 = tagC16;
    {
      final state = State('$s16');
      final r = parser16(state);
      expect(state.ok, true);
      expect(r, '$s16');
      expect(state.pos, 1);
    }
    {
      final state = State('$s16 ');
      final r = parser16(state);
      expect(state.ok, true);
      expect(r, '$s16');
      expect(state.pos, 1);
    }
    {
      final state = State('');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(0, Tag(s16)));
    }
    {
      final state = State(' ');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(0, Tag(s16)));
    }
    final parserC16C32 = tagC16C32;
    {
      final state = State('$s16$s32');
      final r = parserC16C32(state);
      expect(state.ok, true);
      expect(r, '$s16$s32');
      expect(state.pos, 3);
    }
    {
      final state = State('$s16$s32 ');
      final r = parserC16C32(state);
      expect(state.ok, true);
      expect(r, '$s16$s32');
      expect(state.pos, 3);
    }
    {
      final state = State('');
      final r = parserC16C32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(0, Tag(s16 + s32)));
    }
    {
      final state = State(' ');
      final r = parserC16C32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(0, Tag(s16 + s32)));
    }
    final parser32 = tagC32;
    {
      final state = State('$s32');
      final r = parser32(state);
      expect(state.ok, true);
      expect(r, '$s32');
      expect(state.pos, 2);
    }
    {
      final state = State('$s32 ');
      final r = parser32(state);
      expect(state.ok, true);
      expect(r, '$s32');
      expect(state.pos, 2);
    }
    {
      final state = State('');
      final r = parser32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(0, Tag(s32)));
    }
    {
      final state = State(' ');
      final r = parser32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(0, Tag(s32)));
    }
    final parserC32C16 = tagC32C16;
    {
      final state = State('$s32$s16');
      final r = parserC32C16(state);
      expect(state.ok, true);
      expect(r, '$s32$s16');
      expect(state.pos, 3);
    }
    {
      final state = State('$s32$s16 ');
      final r = parserC32C16(state);
      expect(state.ok, true);
      expect(r, '$s32$s16');
      expect(state.pos, 3);
    }
    {
      final state = State('');
      final r = parserC32C16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(0, Tag(s32 + s16)));
    }
    {
      final state = State(' ');
      final r = parserC32C16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(0, Tag(s32 + s16)));
    }
  });
}

void _testTagNoCase() {
  test('TagNoCase', () {
    final parser = tagNoCaseAbc;
    {
      final state = State(abc);
      final r = parser(state);
      expect(state.ok, true);
      expect(r, abc);
      expect(state.pos, 3);
    }
    {
      final state = State('Abc');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'Abc');
      expect(state.pos, 3);
    }
    {
      final state = State('$abc ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, abc);
      expect(state.pos, 3);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(0, Tag(abc)));
    }
    {
      final state = State(' $abc');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(0, Tag(abc)));
    }
  });
}

void _testTagOf() {
  test('TagOf', () {
    final parser = tagOfFoo;
    final foo = 'foo';
    {
      final state = State(foo);
      state.context = _StateContext();
      final r = parser(state);
      expect(state.ok, true);
      expect(r, foo);
      expect(state.pos, 3);
    }
    {
      final state = State('$foo ');
      state.context = _StateContext();
      final r = parser(state);
      expect(state.ok, true);
      expect(r, foo);
      expect(state.pos, 3);
    }
    {
      final state = State('');
      state.context = _StateContext();
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(0, Tag(foo)));
    }
    {
      final state = State(' $foo');
      state.context = _StateContext();
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(0, Tag(foo)));
    }
  });
}

void _testTags() {
  test('Tags', () {
    final parser = tagsAbcAbdDefDegXXY;
    {
      final state = State('abc');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'abc');
      expect(state.pos, 3);
    }
    {
      final state = State('abd');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'abd');
      expect(state.pos, 3);
    }
    {
      final state = State('def');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'def');
      expect(state.pos, 3);
    }
    {
      final state = State('deg');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'deg');
      expect(state.pos, 3);
    }
    {
      final state = State('x');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'x');
      expect(state.pos, 1);
    }
    {
      final state = State('xy');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'xy');
      expect(state.pos, 2);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(
          state.error,
          ErrCombined(0, [
            ErrExpected.tag(0, Tag('abc')),
            ErrExpected.tag(0, Tag('abd')),
            ErrExpected.tag(0, Tag('def')),
            ErrExpected.tag(0, Tag('deg')),
            ErrExpected.tag(0, Tag('x')),
            ErrExpected.tag(0, Tag('xy')),
          ]));
    }
    {
      final state = State('abx');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(
          state.error,
          ErrCombined(0, [
            ErrExpected.tag(0, Tag('abc')),
            ErrExpected.tag(0, Tag('abd')),
            ErrExpected.tag(0, Tag('def')),
            ErrExpected.tag(0, Tag('deg')),
            ErrExpected.tag(0, Tag('x')),
            ErrExpected.tag(0, Tag('xy')),
          ]));
    }
  });
}

void _testTakeUntil() {
  test('TakeUntil', () {
    final parser = takeUntilAbc;
    {
      final state = State('$abc');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '');
      expect(state.pos, 0);
    }
    {
      final state = State('$s16$abc');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '$s16');
      expect(state.pos, 1);
    }
    {
      final state = State('$s16$s32$abc');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '$s16$s32');
      expect(state.pos, 3);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(0, Tag(abc)));
    }
  });
}

void _testTakeUntil1() {
  test('TakeUntil1', () {
    final parser = takeUntil1Abc;
    {
      final state = State('$s16$abc');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '$s16');
      expect(state.pos, 1);
    }
    {
      final state = State('$s16$s32$abc');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '$s16$s32');
      expect(state.pos, 3);
    }
    {
      final state = State('$abc');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrUnexpected.tag(0, Tag('abc')));
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(0, Tag(abc)));
    }
  });
}

void _testTakeWhile() {
  test('TakeWhile', () {
    for (var i = 0; i < 2; i++) {
      final parser = i == 0 ? takeWhileC16 : takeWhileC32;
      //final c = i == 0 ? c16 : c32;
      final s = i == 0 ? s16 : s32;
      final len = i == 0 ? 1 : 2;
      {
        final state = State('');
        final r = parser(state);
        expect(state.ok, true);
        expect(r, '');
        expect(state.pos, 0);
      }
      {
        final state = State(' $s');
        final r = parser(state);
        expect(state.ok, true);
        expect(state.pos, 0);
        expect(r, '');
      }
      {
        final state = State('$s');
        final r = parser(state);
        expect(state.ok, true);
        expect(state.pos, 1 * len);
        expect(r, '$s');
      }
      {
        final state = State('$s$s$s');
        final r = parser(state);
        expect(state.ok, true);
        expect(r, '$s$s$s');
        expect(state.pos, 3 * len);
      }
      {
        final state = State('$s$s$s ');
        final r = parser(state);
        expect(state.ok, true);
        expect(r, '$s$s$s');
        expect(state.pos, 3 * len);
      }
    }
  });
}

void _testTakeWhile1() {
  test('TakeWhile1', () {
    for (var i = 0; i < 2; i++) {
      final parser = i == 0 ? takeWhile1C16 : takeWhile1C32;
      //final c = i == 0 ? c16 : c32;
      final s = i == 0 ? s16 : s32;
      final len = i == 0 ? 1 : 2;
      {
        final state = State('$s');
        final r = parser(state);
        expect(state.ok, true);
        expect(state.pos, 1 * len);
        expect(r, '$s');
      }
      {
        final state = State('$s$s$s');
        final r = parser(state);
        expect(state.ok, true);
        expect(r, '$s$s$s');
        expect(state.pos, 3 * len);
      }
      {
        final state = State('$s$s$s ');
        final r = parser(state);
        expect(state.ok, true);
        expect(r, '$s$s$s');
        expect(state.pos, 3 * len);
      }
      {
        final state = State('');
        final r = parser(state);
        expect(state.ok, false);
        expect(r, null);
        expect(state.pos, 0);
        expect(state.error, ErrUnexpected.eof(0));
      }
      {
        final state = State(' $s');
        final r = parser(state);
        expect(state.ok, false);
        expect(r, null);
        expect(state.pos, 0);
        expect(state.error, ErrUnexpected.char(0, Char(0x20)));
      }
    }
  });
}

void _testTakeWhileMN() {
  test('TakeWhileMN', () {
    for (var i = 0; i < 2; i++) {
      final parser = i == 0 ? takeWhileMN_2_4C16 : takeWhileMN_2_4C32;
      //final c = i == 0 ? c16 : c32;
      final s = i == 0 ? s16 : s32;
      final len = i == 0 ? 1 : 2;
      {
        final state = State('$s$s');
        final r = parser(state);
        expect(state.ok, true);
        expect(r, '$s$s');
        expect(state.pos, 2 * len);
      }
      {
        final state = State('$s$s$s');
        final r = parser(state);
        expect(state.ok, true);
        expect(r, '$s$s$s');
        expect(state.pos, 3 * len);
      }
      {
        final state = State('$s$s$s$s');
        final r = parser(state);
        expect(state.ok, true);
        expect(r, '$s$s$s$s');
        expect(state.pos, 4 * len);
      }
      {
        final state = State('$s$s$s$s$s');
        final r = parser(state);
        expect(state.ok, true);
        expect(r, '$s$s$s$s');
        expect(state.pos, 4 * len);
      }
      {
        final state = State('$s$s$s$s ');
        final r = parser(state);
        expect(state.ok, true);
        expect(r, '$s$s$s$s');
        expect(state.pos, 4 * len);
      }
      {
        final state = State('');
        final r = parser(state);
        expect(r, null);
        expect(state.pos, 0);
        expect(state.error, ErrUnexpected.eof(0));
      }
      {
        final state = State('$s');
        final r = parser(state);
        expect(state.ok, false);
        expect(r, null);
        expect(state.pos, 0);
        expect(state.error, ErrUnexpected.eof(1 * len));
      }
      {
        final sBad = '0';
        final cBad = sBad.codeUnitAt(0);
        final state = State('$s$sBad');
        final r = parser(state);
        expect(state.ok, false);
        expect(r, null);
        expect(state.pos, 0);
        expect(state.error, ErrUnexpected.char(1 * len, Char(cBad)));
      }
      {
        final sBad = '0';
        final cBad = sBad.codeUnitAt(0);
        final state = State('$sBad$s');
        final r = parser(state);
        expect(state.ok, false);
        expect(r, null);
        expect(state.pos, 0);
        expect(state.error, ErrUnexpected.char(0, Char(cBad)));
      }
    }
  });
}

void _testTerminated() {
  test('Terminated', () {
    final parser = terminated;
    {
      final state = State('$s16$s32');
      final r = parser(state);
      expect(r, c16);
      expect(state.ok, true);
      expect(state.pos, 3);
    }
    {
      final state = State('$s32$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c16)));
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c16)));
    }
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(1, Char(c32)));
    }
  });
}

void _testTuple() {
  test('Tuple', () {
    final parser1 = tuple2C32Abc;
    {
      final state = State('$s32$abc');
      final r = parser1(state);
      expect(state.ok, true);
      expect(r, Tuple2(c32, abc));
      expect(state.pos, 5);
    }
    {
      final state = State('');
      final r = parser1(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c32)));
    }
    {
      final state = State('$s32');
      final r = parser1(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(2, Tag(abc)));
    }

    final parser2 = tuple3C32AbcC16;
    {
      final state = State('$s32$abc$s16');
      final r = parser2(state);
      expect(state.ok, true);
      expect(r, Tuple3(c32, abc, c16));
      expect(state.pos, 6);
    }
    {
      final state = State('');
      final r = parser2(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(0, Char(c32)));
    }
    {
      final state = State('$s32');
      final r = parser2(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(2, Tag(abc)));
    }
    {
      final state = State('$s32$abc');
      final r = parser2(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.char(5, Char(c16)));
    }
  });
}

void _testValue() {
  test('Value', () {
    final parser1 = valueAbcToTrueValue;
    {
      final state = State(abc);
      final r = parser1(state);
      expect(state.ok, true);
      expect(r, true);
      expect(state.pos, 3);
    }
    {
      final state = State('');
      final r = parser1(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(0, Tag(abc)));
    }
    {
      final state = State(' ');
      final r = parser1(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrExpected.tag(0, Tag(abc)));
    }

    final parser2 = valueTrue;
    {
      final state = State(abc);
      final r = parser2(state);
      expect(r, true);
      expect(state.ok, true);
      expect(state.pos, 0);
    }
    {
      final state = State('');
      final r = parser2(state);
      expect(state.ok, true);
      expect(r, true);
      expect(state.pos, 0);
    }
    {
      final state = State(' ');
      final r = parser2(state);
      expect(state.ok, true);
      expect(r, true);
      expect(state.pos, 0);
    }
  });
}

void _testVerify() {
  test('Verify', () {
    final parser = verifyIs3Digit;
    {
      final state = State('123');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '123');
      expect(state.pos, 3);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrMessage(0, 0, 'Message'));
    }
    {
      final state = State('12');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.error, ErrMessage(0, 2, 'Message'));
    }
    final parserFast = verifyIs3DigitFast;
    {
      final state = State('123');
      parserFast(state);
      expect(state.ok, true);
      expect(state.pos, 3);
    }
    {
      final state = State('');
      parserFast(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.error, ErrMessage(0, 0, 'Message'));
    }
    {
      final state = State('12');
      parserFast(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.error, ErrMessage(0, 2, 'Message'));
    }
  });
}

class _StateContext {
  final String foo = 'foo';

  final List<int> listOfC16AndC32 = [c16, c32];

  bool isDigit(int c) => c >= 0x30 && c <= 0x39;
}
