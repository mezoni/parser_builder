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
  SemanticAction<bool> _getPredicate() {
    return CharClass('[#x30-#x39] | [#x41-#x46] | [#x61-#x66]');
  }
}
