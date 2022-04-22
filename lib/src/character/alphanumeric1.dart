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
  SemanticAction<bool> _getPredicate() {
    return CharClass('[#x30-#x39] | [#x41-#x5a] | [#x61-#x7a]');
  }
}
