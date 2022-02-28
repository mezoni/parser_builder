part of '../../character.dart';

/// Parses ASCII numeric characters and returns a string containing those
/// characters if at least one such character has been parsed.
///
/// Example:
/// ```dart
/// Digit1()
/// ```
class Digit1 extends _Chars1 {
  const Digit1();

  @override
  Transformer<int, bool> _getCharacterPredicate() {
    return Transformer('c', '=> c >= 0x30 && c <= 0x39;');
  }
}
