part of '../../character.dart';

/// Parse ASCII literal and numeric characters and returns a string containing
/// those characters, or an empty string if no such characters have been parsed.
///
/// Example:
/// ```dart
/// Alphanumeric0()
/// ```
class Alphanumeric0 extends _Chars0 {
  const Alphanumeric0();

  @override
  SemanticAction<bool> _getCharacterPredicate() {
    return CharClass('[#x30-#x39] | [#x41-#x5a] | [#x61-#x7a]');
  }
}
