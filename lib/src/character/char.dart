part of '../../character.dart';

/// Parses one character with code [char] and returns that character.
///
/// Example:
/// ```dart
/// Char(0x30)
/// ```
class Char extends Redirect<String, int> {
  final int char;

  const Char(this.char);

  @override
  ParserBuilder<String, int> getRedirectParser() {
    final isUnicode = char > 0xffff;
    if (isUnicode) {
      return ExpectedChar(Silent(AnyChar()), char);
    } else {
      return ExpectedChar(Silent(CodeUnit()), char);
    }
  }
}
