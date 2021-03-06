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
  SemanticAction<bool> _getPredicate() {
    return CharClass('[#x30-#x39]');
  }
}
