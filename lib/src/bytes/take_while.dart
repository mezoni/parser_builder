part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and returns a substring of
/// the parsed data.
///
/// Example:
/// ```dart
/// TakeWhile(CharClass('[#x21-#x7e]'))
/// ```
class TakeWhile extends Redirect<String, String> {
  final SemanticAction<bool> predicate;

  const TakeWhile(this.predicate);

  @override
  ParserBuilder<String, String> getRedirectParser() {
    return Recognize(Many0(Satisfy(predicate)));
  }
}
