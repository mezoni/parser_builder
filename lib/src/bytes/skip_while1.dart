part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria, and returns true if the
/// criteria was satisfied at least once.
///
/// Example:
/// ```dart
/// SkipWhile1(CharClass('[#x30-#x39]'), unicode: false)
/// ```
class SkipWhile1 extends Redirect<String, void> {
  final SemanticAction<bool> predicate;

  const SkipWhile1(this.predicate);

  @override
  ParserBuilder<String, void> getRedirectParser() {
    final parser = Fast(Many1(Satisfy(predicate)));
    return parser;
  }
}
