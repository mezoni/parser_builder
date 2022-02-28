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
  Transformer<int, bool> _getCharacterPredicate() {
    return Transformer('c',
        '=> c >= 0x30 && c <= 0x39 || c >= 0x41 && c <= 0x5a || c >= 0x61 && c <= 0x7a;');
  }
}
