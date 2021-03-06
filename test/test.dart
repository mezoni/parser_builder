// ignore_for_file: unnecessary_string_interpolations

import 'package:test/test.dart';

import '_test_parser.dart';
import '_token.dart';

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
  _testExpected();
  _testFoldMany0();
  _testHexDigit0();
  _testHexDigit1();
  _testIdentifierExpression();
  _testIndicate();
  _testMany0();
  _testMany0Count();
  _testMany1();
  _testMany1Count();
  _testManyMN();
  _testManyN();
  _testManyTill();
  _testMap();
  _testMap1();
  _testMemoize();
  _testNested();
  _testNoneOf();
  _testNoneOfEx();
  _testNoneOfTags();
  _testNot();
  _testOneOf();
  _testOpt();
  _testPair();
  _testPeek();
  _testPostfixExpression();
  _testPreceded();
  _testPrefixExpression();
  _testRecognize();
  _testRef();
  _testSatisfy();
  _testSeparatedPair();
  _testSeparatedList0();
  _testSeparatedList1();
  _testSeparatedListN();
  _testSkipWhile();
  _testSkipWhile1();
  _testStringValue();
  _testTag();
  _testTagNoCase();
  _testTagOf();
  _testTagPair();
  _testTags();
  _testTagValues();
  _testTakeUntil();
  _testTakeUntil1();
  _testTakeWhile();
  _testTakeWhile1();
  _testTakeWhileMN();
  _testTerminated();
  _testTokenize();
  _testTokenizeSimilarTags();
  _testTokenizeTags();
  _testTuple();
  _testValue();
  _testSemanticActions();
  _testVerify();
}

void _testAlpha0() {
  test('Alpha0', () {
    const parser = alpha0;
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
    const parser = alpha1;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 2, "Unexpected '$s32'")]);
    }
  });
}

void _testAlphanumeric0() {
  test('Alphanumeric0', () {
    const parser = alphanumeric0;
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
    const parser = alphanumeric1;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 2, "Unexpected '$s32'")]);
    }
  });
}

void _testAlt() {
  test('Alt', () {
    const parser = altC16OrC32;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s16', '$s32'")]);
    }
    {
      final state = State(' $s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s16', '$s32'")]);
    }
  });
}

void _testAnd() {
  test('And', () {
    const parser = andC32OrC16;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32', '$s16'")]);
    }
    {
      final state = State(' ');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32', '$s16'")]);
    }
  });
}

void _testAnyChar() {
  test('AnyChar', () {
    const parser = anyChar;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
  });
}

void _testBinaryExpression() {
  test('BinaryExpression', () {
    const parser = binaryExpressionAdd;
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
    {
      final state = State('1+2-a');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 3);
      expect(state.errorPos, 4);
      expect(state.errors, [ParseError(4, 5, "Unexpected 'a'")]);
    }
    {
      final state = State('1+2-');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 3);
      expect(state.errorPos, 4);
      expect(state.errors, [ParseError(4, 4, "Unexpected 'EOF'")]);
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
        expect(state.errorPos, 0);
        expect(state.errors, [ParseError(0, 0, "Expecting: '$s'")]);
      }
      {
        final state = State('');
        final r = parser(state);
        expect(state.ok, false);
        expect(r, null);
        expect(state.pos, 0);
        expect(state.errorPos, 0);
        expect(state.errors, [ParseError(0, 0, "Expecting: '$s'")]);
      }
    }
  });
}

void _testConsumed() {
  test('Consumed', () {
    const parser = consumedSeparatedAbcC32;
    {
      final state = State('$abc$s32$abc');
      final r = parser(state);
      expect(state.ok, true);
      final v = r!;
      expect(v.$0, '$abc$s32$abc');
      expect(v.$1, [abc, abc]);
      expect(state.pos, 8);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'abc'")]);
    }
  });
}

void _testDelimited() {
  test('Delimited', () {
    const parser = delimited;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s16'")]);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s16'")]);
    }
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 1);
      expect(state.errors, [ParseError(1, 1, "Expecting: '$s32'")]);
    }
  });
}

void _testDigit0() {
  test('Digit0', () {
    const parser = digit0;
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
    const parser = digit1;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 2, "Unexpected '$s32'")]);
    }
  });
}

void _testEof() {
  test('Eof', () {
    const parser = eof;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'EOF'")]);
    }
  });
}

void _testEscapeSequence() {
  test('EscapeSequence', () {
    const parser16 = escapeSequence16;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
    {
      final state = State(' ');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 1, "Unexpected ' '")]);
    }
    {
      final state = State('$s32');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 2, "Unexpected '$s32'")]);
    }
    const parser32 = escapeSequence32;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
    {
      final state = State(' ');
      final r = parser32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 1, "Unexpected ' '")]);
    }
  });
}

void _testExpected() {
  test('Expected', () {
    const parser = expected2C16;
    {
      final state = State('$s16$s16');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '$s16$s16');
      expect(state.pos, 2);
    }
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'c16c16'")]);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'c16c16'")]);
    }
    {
      final state = State(' ');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'c16c16'")]);
    }
  });
}

void _testFoldMany0() {
  test('Many0Fold', () {
    const parser = foldMany0Digit;
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
    const parser = hexDigit0;
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
    const parser = hexDigit1;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 2, "Unexpected '$s32'")]);
    }
  });
}

void _testIdentifierExpression() {
  test('IdentifierExpression', () {
    const parser = identifier;
    {
      final state = State('a ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'a');
      expect(state.pos, 1);
    }
    {
      final state = State('z ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'z');
      expect(state.pos, 1);
    }
    {
      final state = State('if1 ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'if1');
      expect(state.pos, 3);
    }
    {
      final state = State('i ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'i');
      expect(state.pos, 1);
    }
    {
      final state = State('for1 ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'for1');
      expect(state.pos, 4);
    }
    {
      final state = State('if ');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'identifier'")]);
    }
    {
      final state = State('while ');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'identifier'")]);
    }
    {
      final state = State('else ');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'identifier'")]);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'identifier'")]);
    }
  });
}

void _testMany0() {
  test('Many0', () {
    const parser16 = many0C16;
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

    const parser32 = many0C32;
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
    const parser = many0CountC32;
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
    const parser = many1C32;
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
    }
  });
}

void _testMany1Count() {
  test('Many1Count', () {
    const parser = many1CountC32;
    {
      final state = State('');
      final r = parser(state);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
    }
  });
}

void _testManyMN() {
  test('ManyMN', () {
    const parser2_3 = manyMNC32_2_3;
    {
      final state = State('');
      final r = parser2_3(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
    }
    {
      final state = State('$s32');
      final r = parser2_3(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 2);
      expect(state.errors, [ParseError(2, 2, "Expecting: '$s32'")]);
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
    }
  });
}

void _testManyN() {
  test('ManyN', () {
    const parser2 = manyNC32_2;
    {
      final state = State('');
      final r = parser2(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
    }
    {
      final state = State('$s32');
      final r = parser2(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 2);
      expect(state.errors, [ParseError(2, 2, "Expecting: '$s32'")]);
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
    }
  });
}

void _testManyTill() {
  test('ManyTill', () {
    const parser = manyTillAOrBTillAbc;
    {
      final state = State('$abc');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, isA<Result2<List<String>, String>>());
      expect(r!.$0, <String>[]);
      expect(r.$1, 'abc');
      expect(state.pos, 3);
    }
    {
      final state = State('a$abc');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, isA<Result2<List<String>, String>>());
      expect(r!.$0, ['a']);
      expect(r.$1, 'abc');
      expect(state.pos, 4);
    }
    {
      final state = State('ab$abc');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, isA<Result2<List<String>, String>>());
      expect(r!.$0, ['a', 'b']);
      expect(r.$1, 'abc');
      expect(state.pos, 5);
    }
    {
      final state = State(' $abc');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'abc', 'a', 'b'")]);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'abc', 'a', 'b'")]);
    }
    {
      final state = State('a');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 1);
      expect(state.errors, [ParseError(1, 1, "Expecting: 'abc', 'a', 'b'")]);
    }
  });
}

void _testMap() {
  test('Map4', () {
    const parser = map4Digits;
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
      expect(state.errorPos, 3);
      expect(state.errors, [ParseError(3, 4, "Unexpected '$s16'")]);
    }
    {
      final state = State('123');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 3);
      expect(state.errors, [ParseError(3, 3, "Unexpected 'EOF'")]);
    }
    {
      final state = State(' ');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 1, "Unexpected ' '")]);
    }
  });
}

void _testMap1() {
  test('Map\$', () {
    const parser = mapC32ToStr;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
    }
  });
}

void _testMemoize() {
  test('Memoize', () {
    const parser = memoizeC16C32OrC16;
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '$s16');
      expect(state.pos, 1);
    }
    {
      final state = State('$s16$s32');
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s16'")]);
    }
    {
      final state = State(' ');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s16'")]);
    }
  });
}

void _testNested() {
  test('Nested', () {
    const parser = nestedC16OrTake2C32;
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, c16);
      expect(state.pos, 1);
    }
    {
      final state = State('$s32$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '$s32$s32');
      expect(state.pos, 4);
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 2);
      expect(state.errors, [ParseError(2, 2, "Unexpected 'EOF'")]);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'nested'")]);
    }
    {
      final state = State(' ');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'nested'")]);
    }
  });
}

void _testNoneOf() {
  test('NoneOf', () {
    const parser16 = noneOfC16;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 1, "Unexpected '$s16'")]);
    }
    {
      final state = State('');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }

    const parser32 = noneOfC32;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 2, "Unexpected '$s32'")]);
    }
    {
      final state = State('');
      final r = parser32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
  });
}

void _testNoneOfEx() {
  test('NoneOfOf', () {
    const parser1 = noneOfOfC16OrC32;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
    {
      final state = State('$s16');
      state.context = _StateContext();
      final r = parser1(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 1, "Unexpected '$s16'")]);
    }
    {
      final state = State('$s32');
      state.context = _StateContext();
      final r = parser1(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 2, "Unexpected '$s32'")]);
    }
  });
}

void _testNoneOfTags() {
  test('NoneOfTags', () {
    const parser = noneOfTagsAbcAbdDefDegXXY;
    {
      final state = State('abc');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 3, "Unexpected 'abc'")]);
    }
    {
      final state = State('abd');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 3, "Unexpected 'abd'")]);
    }
    {
      final state = State('def');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 3, "Unexpected 'def'")]);
    }
    {
      final state = State('deg');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 3, "Unexpected 'deg'")]);
    }
    {
      final state = State('x');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 1, "Unexpected 'x'")]);
    }
    {
      final state = State('xy');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 2, "Unexpected 'xy'")]);
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
    const parser = notC32OrC16;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, 'Unknown error')]);
    }
    {
      final state = State('$s32');
      parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, 'Unknown error')]);
    }
  });
}

void _testOneOf() {
  test('OneOf', () {
    const parser16 = oneOfC16;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 2, "Unexpected '$s32'")]);
    }
    {
      final state = State('a');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 1, "Unexpected 'a'")]);
    }
    {
      final state = State('');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }

    const parser32 = oneOfC32;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 1, "Unexpected '$s16'")]);
    }
    {
      final state = State('a');
      final r = parser32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 1, "Unexpected 'a'")]);
    }
    {
      final state = State('');
      final r = parser32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
  });
}

void _testOpt() {
  test('Opt', () {
    const parser = optAbc;
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
    const parser = pairC16C32;
    {
      final state = State('$s16$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, Result2(c16, c32));
      expect(state.pos, 3);
    }
    {
      final state = State('$s32$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s16'")]);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s16'")]);
    }
  });
}

void _testPeek() {
  test('Peek', () {
    const parser = peekC32;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
    }
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
    }
  });
}

void _testPostfixExpression() {
  test('PostfixExpression', () {
    const parser = postfixExpression;
    {
      final state = State('1');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 1);
      expect(state.pos, 1);
    }
    {
      final state = State('1++');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 2);
      expect(state.pos, 3);
    }
    {
      final state = State('1+++');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 2);
      expect(state.pos, 3);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
    {
      final state = State(' ');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 1, "Unexpected ' '")]);
    }
  });
}

void _testPreceded() {
  test('Preceded', () {
    const parser = precededC16C32;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s16'")]);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s16'")]);
    }
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 1);
      expect(state.errors, [ParseError(1, 1, "Expecting: '$s32'")]);
    }
  });
}

void _testPrefixExpression() {
  test('PrefixExpression', () {
    const parser = prefixExpression;
    {
      final state = State('1');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 1);
      expect(state.pos, 1);
    }
    {
      final state = State('++1');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 2);
      expect(state.pos, 3);
    }
    {
      final state = State('--1');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 0);
      expect(state.pos, 3);
    }
    {
      final state = State('-1');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, -1);
      expect(state.pos, 2);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
    {
      final state = State(' ');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 1, "Unexpected ' '")]);
    }
    {
      final state = State('++');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 2);
      expect(state.errors, [ParseError(2, 2, "Unexpected 'EOF'")]);
    }
  });
}

void _testRecognize() {
  test('Recognize', () {
    const parser = recognize3C32AbcC16;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
    }
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 2);
      expect(state.errors, [ParseError(2, 2, "Expecting: 'abc'")]);
    }
    {
      final state = State('$s32$abc');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 5);
      expect(state.errors, [ParseError(5, 5, "Expecting: '$s16'")]);
    }
  });
}

void _testRef() {
  test('Ref', () {
    const parser = testRef;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s16'")]);
    }
  });
}

void _testIndicate() {
  test('Indicate', () {
    const parser = indicateAbc4Digits;
    {
      final state = State('abc1234');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '1234');
      expect(state.pos, 7);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$abc'")]);
    }
    {
      final state = State('abc');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 3);
      expect(state.errors, [
        ParseError(3, 3, "Unexpected 'EOF'"),
        ParseError(3, 3, 'indicate'),
      ]);
    }
    {
      final state = State('abc123');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 6);
      expect(state.errors, [
        ParseError(6, 6, "Unexpected 'EOF'"),
        ParseError(3, 6, 'indicate'),
      ]);
    }
  });
}

void _testSatisfy() {
  test('Satisfy', () {
    const parser16 = satisfyC16;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
    {
      final state = State('$s32');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 2, "Unexpected '$s32'")]);
    }

    const parser32 = satisfyC32;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
    {
      final state = State('$s16');
      final r = parser32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 1, "Unexpected '$s16'")]);
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
      const parser = transformersVarIsNotDigit;
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
        expect(state.errorPos, 0);
        expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
      }
      {
        final state = State('1');
        final r = parser(state);
        expect(state.ok, false);
        expect(r, null);
        expect(state.pos, 0);
        expect(state.errorPos, 0);
        expect(state.errors, [ParseError(0, 1, "Unexpected '1'")]);
      }
    });
  }
}

void _testSeparatedList0() {
  test('SeparatedList0', () {
    const parser = separatedList0C32Abc;
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
    const parser = separatedList1C32Abc;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
    }
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
    }
  });
}

void _testSeparatedListN() {
  test('SeparatedListN', () {
    const parser = separatedListN_2C32Abc;
    {
      final state = State('$s32');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 2);
      expect(state.errors, [ParseError(2, 2, "Expecting: 'abc'")]);
    }
    {
      final state = State('$s32$abc');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 5);
      expect(state.errors, [ParseError(5, 5, "Expecting: '$s32'")]);
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
      final state = State('$s32$abc$s32$abc$s32');
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
    }
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
    }
  });
}

void _testSeparatedPair() {
  test('SeparatedPair', () {
    const parser = separatedPairC16AbcC32;
    {
      final state = State('$s16$abc$s32');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, Result2(c16, c32));
      expect(state.pos, 6);
    }
    {
      final state = State('$s16$abc');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 4);
      expect(state.errors, [ParseError(4, 4, "Expecting: '$s32'")]);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s16'")]);
    }
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 1);
      expect(state.errors, [ParseError(1, 1, "Expecting: 'abc'")]);
    }
  });
}

void _testSkipWhile() {
  test('SkipWhile', () {
    const parser16 = skipWhileC16;
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
    const parser32 = skipWhileC32;
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
    const parser16 = skipWhile1C16;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
    {
      final state = State('$s32');
      parser16(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 2, "Unexpected '$s32'")]);
    }
    const parser32 = skipWhile1C32;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
    {
      final state = State('$s16');
      parser32(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 1, "Unexpected '$s16'")]);
    }
  });
}

void _testStringValue() {
  test('StringValue', () {
    const parser = stringValue;
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
    const parser16 = tagC16;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s16'")]);
    }
    {
      final state = State(' ');
      final r = parser16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s16'")]);
    }
    const parserC16C32 = tagC16C32;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s16$s32'")]);
    }
    {
      final state = State(' ');
      final r = parserC16C32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s16$s32'")]);
    }
    const parser32 = tagC32;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
    }
    {
      final state = State(' ');
      final r = parser32(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
    }
    const parserC32C16 = tagC32C16;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32$s16'")]);
    }
    {
      final state = State(' ');
      final r = parserC32C16(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32$s16'")]);
    }
  });
}

void _testTagNoCase() {
  test('TagNoCase', () {
    const parser = tagNoCaseAbc;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'abc'")]);
    }
    {
      final state = State(' $abc');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'abc'")]);
    }
  });
}

void _testTagOf() {
  test('TagOf', () {
    const parser = tagOfFoo;
    const foo = 'foo';
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'foo'")]);
    }
    {
      final state = State(' $foo');
      state.context = _StateContext();
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'foo'")]);
    }
  });
}

void _testTagPair() {
  test('TagPair', () {
    const parser = tagPairAbc;
    {
      final state = State(r'<abc>123<\abc>');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, '123');
      expect(state.pos, 14);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '<'")]);
    }
    {
      final state = State(r'<abc>123');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 8);
      expect(state.errors, [ParseError(8, 8, r"Expecting: '<\'")]);
    }
    {
      final state = State(r'<abc>123<\def');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 13);
      expect(state.errors, [ParseError(13, 13, r"Expecting: '>'")]);
    }
    {
      final state = State(r'<abc>123<\def>');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 14);
      expect(state.errors, [
        ParseError(0, 5, "Start tag 'abc' does not match end tag 'def'"),
        ParseError(8, 14, "End tag 'def' does not match start tag 'abc'"),
      ]);
    }
  });
}

void _testTags() {
  test('Tags', () {
    const parser = tagsAbcAbdDefDegXXYZ;
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
      final state = State('z');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, 'z');
      expect(state.pos, 1);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [
        ParseError(
            0, 0, "Expecting: 'abc', 'abd', 'def', 'deg', 'x', 'xy', 'z'")
      ]);
    }
    {
      final state = State('abx');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [
        ParseError(
            0, 0, "Expecting: 'abc', 'abd', 'def', 'deg', 'x', 'xy', 'z'")
      ]);
    }
  });
}

void _testTagValues() {
  test('TagValues', () {
    const parser = tagValues;
    {
      final state = State('false ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, false);
      expect(state.pos, 5);
    }
    {
      final state = State('true ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, true);
      expect(state.pos, 4);
    }
    {
      final state = State('null ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, null);
      expect(state.pos, 4);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors,
          [ParseError(0, 0, "Expecting: 'false', 'true', 'null'")]);
    }
    {
      final state = State(' ');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors,
          [ParseError(0, 0, "Expecting: 'false', 'true', 'null'")]);
    }
  });
}

void _testTakeUntil() {
  test('TakeUntil', () {
    const parser = takeUntilAbc;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'abc'")]);
    }
  });
}

void _testTakeUntil1() {
  test('TakeUntil1', () {
    const parser = takeUntil1Abc;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 3, "Unexpected 'abc'")]);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
    {
      final state = State(' ');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 1);
      expect(state.errors, [ParseError(1, 1, "Expecting: 'abc'")]);
    }
    {
      final state = State('  ');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 1);
      expect(state.errors, [ParseError(1, 1, "Expecting: 'abc'")]);
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
        expect(state.errorPos, 0);
        expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
      }
      {
        final state = State(' $s');
        final r = parser(state);
        expect(state.ok, false);
        expect(r, null);
        expect(state.pos, 0);
        expect(state.errorPos, 0);
        expect(state.errors, [ParseError(0, 1, "Unexpected ' '")]);
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
        expect(state.errorPos, 0);
        expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
      }
      {
        final state = State('$s');
        final r = parser(state);
        expect(state.ok, false);
        expect(r, null);
        expect(state.pos, 0);
        expect(state.errorPos, 1 * len);
        expect(
            state.errors, [ParseError(1 * len, 1 * len, "Unexpected 'EOF'")]);
      }
      {
        const sBad = '0';
        final state = State('$s$sBad');
        final r = parser(state);
        expect(state.ok, false);
        expect(r, null);
        expect(state.pos, 0);
        expect(state.errorPos, 1 * len);
        expect(
            state.errors, [ParseError(1 * len, 1 * len + 1, "Unexpected '0'")]);
      }
      {
        const sBad = '0';
        final state = State('$sBad$s');
        final r = parser(state);
        expect(state.ok, false);
        expect(r, null);
        expect(state.pos, 0);
        expect(state.errorPos, 0);
        expect(state.errors, [ParseError(0, 1, "Unexpected '0'")]);
      }
    }
  });
}

void _testTerminated() {
  test('Terminated', () {
    const parser = terminated;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s16'")]);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s16'")]);
    }
    {
      final state = State('$s16');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 1);
      expect(state.errors, [ParseError(1, 1, "Expecting: '$s32'")]);
    }
  });
}

void _testTokenize() {
  test('Tokenize', () {
    const parser = tokenizeAlphaOrDigits;
    {
      final state = State('123');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, Token(TokenKind.number, '123', 0, 3, 123));
      expect(state.pos, 3);
    }
    {
      final state = State('abc');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, Token(TokenKind.text, 'abc', 0, 3, 'abc'));
      expect(state.pos, 3);
    }
    {
      const source = '';
      final state = State(source);
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
    {
      const source = ' ';
      final state = State(source);
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errors, [ParseError(0, 1, "Unexpected ' '")]);
    }
  });
}

void _testTokenizeSimilarTags() {
  test('TokenizeSimilarTags', () {
    const parser = tokenizeSimilarTagsIfForWhile;
    {
      final state = State('if');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, Token(TokenKind.text, 'if', 0, 2, 'if'));
      expect(state.pos, 2);
    }
    {
      final state = State('for');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, Token(TokenKind.text, 'for', 0, 3, 'for'));
      expect(state.pos, 3);
    }
    {
      final state = State('while');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, Token(TokenKind.text, 'while', 0, 5, 'while'));
      expect(state.pos, 5);
    }
    {
      const source = '';
      final state = State(source);
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
    {
      const source = ' ';
      final state = State(source);
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errors, [ParseError(0, 1, "Unexpected ' '")]);
    }
  });
}

void _testTokenizeTags() {
  test('TokenizeTags', () {
    const parser = tokenizeTagsIfForWhile;
    {
      final state = State('if');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, Token(TokenKind.text, 'if', 0, 2, 'if'));
      expect(state.pos, 2);
    }
    {
      final state = State('for');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, Token(TokenKind.text, 'for', 0, 3, 'for'));
      expect(state.pos, 3);
    }
    {
      final state = State('while');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, Token(TokenKind.text, 'while', 0, 5, 'while'));
      expect(state.pos, 5);
    }
    {
      const source = '';
      final state = State(source);
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errors, [ParseError(0, 0, "Unexpected 'EOF'")]);
    }
    {
      const source = ' ';
      final state = State(source);
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errors, [ParseError(0, 1, "Unexpected ' '")]);
    }
  });
}

void _testTuple() {
  test('Tuple', () {
    const parser1 = tuple2C32Abc;
    {
      final state = State('$s32$abc');
      final r = parser1(state);
      expect(state.ok, true);
      expect(r, Result2(c32, abc));
      expect(state.pos, 5);
    }
    {
      final state = State('');
      final r = parser1(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
    }
    {
      final state = State('$s32');
      final r = parser1(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 2);
      expect(state.errors, [ParseError(2, 2, "Expecting: 'abc'")]);
    }

    const parser2 = tuple3C32AbcC16;
    {
      final state = State('$s32$abc$s16');
      final r = parser2(state);
      expect(state.ok, true);
      expect(r, Result3(c32, abc, c16));
      expect(state.pos, 6);
    }
    {
      final state = State('');
      final r = parser2(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: '$s32'")]);
    }
    {
      final state = State('$s32');
      final r = parser2(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 2);
      expect(state.errors, [ParseError(2, 2, "Expecting: 'abc'")]);
    }
    {
      final state = State('$s32$abc');
      final r = parser2(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 5);
      expect(state.errors, [ParseError(5, 5, "Expecting: '$s16'")]);
    }
  });
}

void _testValue() {
  test('Value', () {
    const parser1 = valueAbcToTrueValue;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'abc'")]);
    }
    {
      final state = State(' ');
      final r = parser1(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, "Expecting: 'abc'")]);
    }

    const parser2 = valueTrue;
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
    const parser = verifyIs3Digit;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, 'Message')]);
    }
    {
      final state = State('12');
      final r = parser(state);
      expect(state.ok, false);
      expect(r, null);
      expect(state.pos, 0);
      expect(state.errorPos, 2);
      expect(state.errors, [ParseError(0, 2, 'Message')]);
    }
    const parserFast = verifyIs3DigitFast;
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
      expect(state.errorPos, 0);
      expect(state.errors, [ParseError(0, 0, 'Message')]);
    }
    {
      final state = State('12');
      parserFast(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(state.errorPos, 2);
      expect(state.errors, [ParseError(0, 2, 'Message')]);
    }
  });
}

class _StateContext {
  final String foo = 'foo';

  final List<int> listOfC16AndC32 = [c16, c32];

  bool isDigit(int c) => c >= 0x30 && c <= 0x39;
}
