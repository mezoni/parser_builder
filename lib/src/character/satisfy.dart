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
    if (predicate.isUnicode) {
      return UnexpectedCharOrEof(Silent(AnyChar()), predicate);
    } else {
      return UnexpectedCharOrEof(Silent(CodeUnit()), predicate);
    }
  }
}
