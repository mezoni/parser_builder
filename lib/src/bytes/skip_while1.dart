part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria, and returns true if the
/// criteria was satisfied at least once.
///
/// Example:
/// ```dart
/// SkipWhile1(CharClass('[#x30-#x39]'), unicode: false)
/// ```
class SkipWhile1 extends StringParserBuilder<void> {
  final SemanticAction<bool> predicate;

  const SkipWhile1(this.predicate);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final parser = Fast(Many1(Satisfy(predicate)));
    parser.build(context, code, result, silent);
  }
}
