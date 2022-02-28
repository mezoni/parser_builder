part of '../../character.dart';

/// Parse ASCII literal and numeric characters and returns a string containing
/// those characters if at least one such character has been parsed.
///
/// Example:
/// ```dart
/// Alphanumeric1()
/// ```
class Alphanumeric1 extends _Chars1 {
  const Alphanumeric1();

  @override
  Transformer<int, bool> _getCharacterPredicate() {
    return Transformer('c',
        '=> c >= 0x30 && c <= 0x39 || c >= 0x41 && c <= 0x5a || c >= 0x61 && c <= 0x7a;');
  }
}
