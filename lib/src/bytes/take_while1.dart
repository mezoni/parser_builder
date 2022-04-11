part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and returns a substring of
/// the parsed data if the criteria was satisfied at least once.
///
/// Example:
/// ```dart
/// TakeWhile1(CharClass('[A-Z] | [a-z] |  "_"'))
/// ```
class TakeWhile1 extends StringParserBuilder<String> {
  final SemanticAction<bool> predicate;

  const TakeWhile1(this.predicate);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final parser = Recognize(Many1(Satisfy(predicate)));
    parser.build(context, code, result, silent);
  }
}
