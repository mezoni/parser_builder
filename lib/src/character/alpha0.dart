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
    return CharClass('[#x41-#x5a] | [#x61-#x7a]');
  }
}
