part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria, and returns true.
///
/// Example:
/// ```dart
/// SkipWhile(CharClass('#x9 | #xA | #xD | #x20'))
/// ```
class SkipWhile extends StringParserBuilder<void> {
  final SemanticAction<bool> predicate;

  const SkipWhile(this.predicate);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final parser = Fast(Many0(Satisfy(predicate)));
    parser.build(context, code, result, silent);
  }
}
