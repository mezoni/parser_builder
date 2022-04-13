part of '../../parser_builder.dart';

class Marked<I, O> extends Redirect<I, O> {
  final String name;

  final ParserBuilder<I, O> parser;

  const Marked(this.name, this.parser);

  @override
  ParserBuilder<I, O> getRedirectParser() {
    return parser;
  }
}
