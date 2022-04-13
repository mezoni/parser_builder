part of '../../combinator.dart';

class Opt<I, O> extends Redirect<I, O?> {
  final ParserBuilder<I, O> parser;

  const Opt(this.parser);

  @override
  ParserBuilder<I, O?> getRedirectParser() {
    final parser = Silent<I, O?>(Alt2(this.parser, Value(null)));
    return parser;
  }
}
