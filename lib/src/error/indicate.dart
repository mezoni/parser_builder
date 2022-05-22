part of '../../error.dart';

/// Parses [parser] and returns the result of parsing.
///
/// This parser works as follows:
///
/// If a parsing errors occurs, then an `ParseError.message(message)` error is
/// generated and all other errors are generated as well.
@experimental
class Indicate<I, O> extends ParserBuilder<I, O> {
  final String message;

  final ParserBuilder<I, O> parser;

  const Indicate(this.message, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    return WithStartAndLastErrorPos(Alt2(
      parser,
      FailMessage(StatePos.lastErrorPos, message, StatePos.start),
    )).build(context, result);
  }
}
