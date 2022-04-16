part of '../../combinator.dart';

class Recognize<I> extends Redirect<I, I> {
  final ParserBuilder<I, dynamic> parser;

  const Recognize(this.parser);

  @override
  ParserBuilder<I, I> getRedirectParser() {
    return Slice(parser);
  }
}
