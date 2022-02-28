part of '../../character.dart';

/// Parses ASCII literal characters and returns a string containing those
/// characters, or an empty string if no such characters have been parsed.
///
/// Example:
/// ```dart
/// Alpha0()
/// ```
class Alpha0 extends _Chars0 {
  const Alpha0();

  @override
  Transformer<int, bool> _getCharacterPredicate() {
    return Transformer(
        'c', '=> c >= 0x41 && c <= 0x5a || c >= 0x61 && c <= 0x7a;');
  }
}
