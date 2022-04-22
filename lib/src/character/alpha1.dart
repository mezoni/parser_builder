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
  SemanticAction<bool> _getPredicate() {
    return CharClass('[#x41-#x5a] | [#x61-#x7a]');
  }
}
