part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and returns a substring of
/// the parsed data.
///
/// Example:
/// ```dart
/// TakeWhile(CharClass('[#x21-#x7e]'))
/// ```
class TakeWhile extends StringParserBuilder<String> {
  final SemanticAction<bool> predicate;

  const TakeWhile(this.predicate);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final parser = Recognize(Many0(Satisfy(predicate)));
    parser.build(context, code, result, silent);
  }
}
