part of '../../error.dart';

/// Parses [parser] and returns the result of parsing.
///
/// This parser works as follows:
///
/// If a parsing errors occurs, then an `ParseError.expected(tag)` error is
/// generated instead of these errors.
class Expected<I, O> extends ParserBuilder<I, O> {
  final ParserBuilder<I, O> parser;

  final String tag;

  const Expected(this.tag, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    return Alt2<I, O>(Silent(parser), FailExpected(FailPos.pos, tag))
        .build(context, result);
  }
}
