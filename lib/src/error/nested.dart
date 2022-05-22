part of '../../error.dart';

/// Parses [parser] and returns the result of parsing.
///
/// This parser works as follows:
///
/// If a parsing errors occurs at the start position, then an
/// `ParseError.expected('tag')` error is generated instead of these errors.
///
/// If a parsing errors occurs at the next positions, then all other errors are
/// generated as well.
class Nested<I, O> extends ParserBuilder<I, O> {
  final ParserBuilder<I, O> parser;

  final String tag;

  const Nested(this.tag, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    return Alt2(SilentAtThisPos(parser), FailExpected(StatePos.pos, tag))
        .build(context, result);
  }
}
