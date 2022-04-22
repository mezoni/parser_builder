part of '../../character.dart';

/// Parses ASCII numeric characters and returns a string containing those
/// characters, or an empty string if no such characters have been parsed.
///
/// Example:
/// ```dart
/// Digit0()
/// ```
class Digit0 extends _Chars0 {
  const Digit0();

  @override
  SemanticAction<bool> _getPredicate() {
    return CharClass('[#x30-#x39]');
  }
}
