part of '../../character.dart';

/// Parse ASCII hexadecimal numeric characters and returns a string containing
/// those characters, or an empty string if no such characters have been parsed.
///
/// Example:
/// ```dart
/// HexDigit0()
/// ```
class HexDigit0 extends _Chars0 {
  const HexDigit0();

  @override
  Transformer<int, bool> _getCharacterPredicate() {
    return Transformer('c',
        '=> c >= 0x30 && c <= 0x39 || c >= 0x41 && c <= 0x46 || c >= 0x61 && c <= 0x66;');
  }
}
