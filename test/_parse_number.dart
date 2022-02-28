import 'package:tuple/tuple.dart';

Tuple2<int, num?> parseNumber(String source, int position) {
  // Based on https://github.com/dart-lang/sdk/blob/master/sdk/lib/_internal/vm/lib/convert_patch.dart
  const powersOfTen = [
    1.0,
    10.0,
    100.0,
    1000.0,
    10000.0,
    100000.0,
    1000000.0,
    10000000.0,
    100000000.0,
    1000000000.0,
    10000000000.0,
    100000000000.0,
    1000000000000.0,
    10000000000000.0,
    100000000000000.0,
    1000000000000000.0,
    10000000000000000.0,
    100000000000000000.0,
    1000000000000000000.0,
    10000000000000000000.0,
    100000000000000000000.0,
    1000000000000000000000.0,
    10000000000000000000000.0,
  ];

  // ignore: constant_identifier_names
  const MINUS = 0x2d;
  // ignore: constant_identifier_names
  const CHAR_0 = 0x30;
  // ignore: constant_identifier_names
  const CHAR_e = 0x65;
  // ignore: constant_identifier_names
  const DECIMALPOINT = 0x2e;

  Tuple2<int, num?> error(int position) {
    return Tuple2(position, null);
  }

  Tuple2<int, num?> handleNumber(int position, num number) {
    return Tuple2(position, number);
  }

  String getString(int start, int end) {
    return source.substring(start, end);
  }

  double parseDouble(int start, int end) {
    return double.parse(getString(start, end));
  }

  if (position == source.length) {
    return error(position);
  }

  int getChar(int index) {
    return source.codeUnitAt(index);
  }

  var char = getChar(position);

  // Also called on any unexpected character.
  // Format:
  //  '-'?('0'|[1-9][0-9]*)('.'[0-9]+)?([eE][+-]?[0-9]+)?
  int start = position;
  int length = source.length;
  // Collects an int value while parsing. Used for both an integer literal,
  // and the exponent part of a double literal.
  // Stored as negative to ensure we can represent -2^63.
  int intValue = 0;
  double doubleValue = 0.0; // Collect double value while parsing.
  // 1 if there is no leading -, -1 if there is.
  int sign = 1;
  bool isDouble = false;
  // Break this block when the end of the number literal is reached.
  // At that time, position points to the next character, and isDouble
  // is set if the literal contains a decimal point or an exponential.
  if (char == MINUS) {
    sign = -1;
    position++;
    if (position == length) return error(position);
    char = getChar(position);
  }
  int digit = char ^ CHAR_0;
  if (digit > 9) {
    if (sign < 0) {
      return error(position);
    } else {
      // If it doesn't even start out as a numeral.
      return error(position);
    }
  }
  if (digit == 0) {
    position++;
    if (position == length) return handleNumber(position, 0);
    char = getChar(position);
    digit = char ^ CHAR_0;
    // If starting with zero, next character must not be digit.
    if (digit <= 9) return error(position);
  } else {
    int digitCount = 0;
    do {
      if (digitCount >= 18) {
        // Check for overflow.
        // Is 1 if digit is 8 or 9 and sign == 0, or digit is 9 and sign < 0;
        int highDigit = digit >> 3;
        if (sign < 0) highDigit &= digit;
        if (digitCount == 19 || intValue - highDigit < -922337203685477580) {
          isDouble = true;
          // Big value that we know is not trusted to be exact later,
          // forcing reparsing using `double.parse`.
          doubleValue = 9223372036854775808.0;
        }
      }
      intValue = 10 * intValue - digit;
      digitCount++;
      position++;
      if (position == length) {
        return handleNumber(position, sign < 0 ? intValue : -intValue);
      }
      char = getChar(position);
      digit = char ^ CHAR_0;
    } while (digit <= 9);
  }
  if (char == DECIMALPOINT) {
    if (!isDouble) {
      isDouble = true;
      doubleValue = (intValue == 0) ? 0.0 : -intValue.toDouble();
    }
    intValue = 0;
    position++;
    if (position == length) return error(position);
    char = getChar(position);
    digit = char ^ CHAR_0;
    if (digit > 9) return error(position);
    do {
      doubleValue = 10.0 * doubleValue + digit;
      intValue -= 1;
      position++;
      //if (position == length) return unexpectedEof(position);
      if (position == length) break;
      char = getChar(position);
      digit = char ^ CHAR_0;
    } while (digit <= 9);
  }
  if ((char | 0x20) == CHAR_e) {
    if (!isDouble) {
      isDouble = true;
      doubleValue = (intValue == 0) ? 0.0 : -intValue.toDouble();
      intValue = 0;
    }
    position++;
    if (position == length) return error(position);
    char = getChar(position);
    int expSign = 1;
    int exponent = 0;
    if (((char + 1) | 2) == 0x2e /*+ or -*/) {
      expSign = 0x2C - char; // -1 for MINUS, +1 for PLUS
      position++;
      if (position == length) return error(position);
      char = getChar(position);
    }
    digit = char ^ CHAR_0;
    if (digit > 9) {
      return error(position);
    }
    bool exponentOverflow = false;
    do {
      exponent = 10 * exponent + digit;
      if (exponent > 400) exponentOverflow = true;
      position++;
      if (position == length) break;
      char = getChar(position);
      digit = char ^ CHAR_0;
    } while (digit <= 9);
    if (exponentOverflow) {
      if (doubleValue == 0.0 || expSign < 0) {
        return handleNumber(position, sign < 0 ? -0.0 : 0.0);
      } else {
        return handleNumber(
            position, sign < 0 ? double.negativeInfinity : double.infinity);
      }
    }
    intValue += expSign * exponent;
  }
  if (!isDouble) {
    int bitFlag = -(sign + 1) >> 1; // 0 if sign == -1, -1 if sign == 1
    // Negate if bitFlag is -1 by doing ~intValue + 1
    return handleNumber(position, (intValue ^ bitFlag) - bitFlag);
  }
  // Double values at or above this value (2 ** 53) may have lost precision.
  // Only trust results that are below this value.
  const double maxExactDouble = 9007199254740992.0;
  if (doubleValue < maxExactDouble) {
    int exponent = intValue;
    double signedMantissa = doubleValue * sign;
    if (exponent >= -22) {
      if (exponent < 0) {
        return handleNumber(position, signedMantissa / powersOfTen[-exponent]);
      }
      if (exponent == 0) {
        return handleNumber(position, signedMantissa);
      }
      if (exponent <= 22) {
        return handleNumber(position, signedMantissa * powersOfTen[exponent]);
      }
    }
  }
  // If the value is outside the range +/-maxExactDouble or
  // exponent is outside the range +/-22, then we can't trust simple double
  // arithmetic to get the exact result, so we use the system double parsing.
  return handleNumber(position, parseDouble(start, position));
}
