part of '../../combinator.dart';

class Opt<I, O> extends Redirect<I, O?> {
  final ParserBuilder<I, O> parser;

  const Opt(this.parser);

  @override
  ParserBuilder<I, O?> getRedirectParser() {
    return Silent(Alt2(parser, Value(null)));
  }
}
