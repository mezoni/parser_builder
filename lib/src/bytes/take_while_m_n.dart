part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and returns a substring of
/// the parsed data if the criteria were satisfied [m] to [n] times.
///
/// Example:
/// ```dart
/// TakeWhileMN(4, 4, CharClass('[0-9] | [a-f] | [A-F]'))
/// ```
class TakeWhileMN extends Redirect<String, String> {
  final int m;

  final int n;

  final SemanticAction<bool> predicate;

  const TakeWhileMN(this.m, this.n, this.predicate);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final parser = Recognize(ManyMN(m, n, Satisfy(predicate)));
    return parser.build(context, code, result, silent);
  }

  @override
  ParserBuilder<String, String> getRedirectParser() {
    final parser = Recognize(ManyMN(m, n, Satisfy(predicate)));
    return parser;
  }
}
