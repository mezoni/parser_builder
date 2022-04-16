part of '../../character.dart';

/// Parses a single character, and if [chars] satisfies the criteria,
/// returns that character.
///
/// Example:
/// ```dart
/// Satisfy(isSomeChar)
/// ```
class Satisfy extends Redirect<String, int> {
  final SemanticAction<bool> predicate;

  const Satisfy(this.predicate);

  @override
  ParserBuilder<String, int> getRedirectParser() {
    final error = ExprAction([], 'ErrUnexpected.charOrEof(state.pos, source)');
    if (predicate.isUnicode) {
      return Check(Silent(AnyChar()), predicate, error);
    } else {
      return Check(Silent(CodeUnit()), predicate, error);
    }
  }
}
