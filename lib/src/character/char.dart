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
    final predicate = ExprAction<bool>(['c'], '{{c}} == $char');
    final error =
        ExprAction([], 'ErrExpected.char(state.pos, const Char($char))');
    final isUnicode = char > 0xffff;
    if (isUnicode) {
      return Check(Silent(AnyChar()), predicate, error);
    } else {
      return Check(Silent(CodeUnit()), predicate, error);
    }
  }
}
