part of '../../combinator.dart';

class And<I> extends Redirect<I, void> {
  final ParserBuilder<I, dynamic> parser;

  const And(this.parser);

  @override
  ParserBuilder<I, void> getRedirectParser() {
    return Peek(Fast(parser));
  }
}
