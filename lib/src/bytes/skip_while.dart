part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria, and returns true.
///
/// Example:
/// ```dart
/// SkipWhile(CharClass('#x9 | #xA | #xD | #x20'))
/// ```
class SkipWhile extends Redirect<String, void> {
  final SemanticAction<bool> predicate;

  const SkipWhile(this.predicate);

  @override
  ParserBuilder<String, void> getRedirectParser() {
    final parser = Fast(Many0(Satisfy(predicate)));
    return parser;
  }
}
