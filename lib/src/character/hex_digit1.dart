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
    return CharClass('[#x30-#x39] | [#x41-#x46] | [#x61-#x66]');
  }
}
