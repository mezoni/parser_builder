part of '../../character.dart';

/// Parses ASCII literal characters and returns a string containing those
/// characters if at least one such character has been parsed.
///
/// Example:
/// ```dart
/// Alpha1()
/// ```
class Alpha1 extends _Chars1 {
  const Alpha1();

  @override
  Transformer<int, bool> _getCharacterPredicate() {
    return Transformer(
        'c', '=> c >= 0x41 && c <= 0x5a || c >= 0x61 && c <= 0x7a;');
  }
}
