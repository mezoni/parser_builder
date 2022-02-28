part of '../../character.dart';

/// Parse ASCII hexadecimal numeric characters and returns a string containing
/// those characters if at least one such character has been parsed.
///
/// Example:
/// ```dart
/// HexDigit1()
/// ```
class HexDigit1 extends _Chars1 {
  const HexDigit1();

  @override
  Transformer<int, bool> _getCharacterPredicate() {
    return Transformer('c',
        '=> c >= 0x30 && c <= 0x39 || c >= 0x41 && c <= 0x46 || c >= 0x61 && c <= 0x66;');
  }
}
