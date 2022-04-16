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
  ParserBuilder<String, String> getRedirectParser() {
    return Recognize(ManyMN(m, n, Satisfy(predicate)));
  }
}
