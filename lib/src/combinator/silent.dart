part of '../../combinator.dart';

class Silent<I, O> extends UnaryParserBuilder<I, O> {
  const Silent(ParserBuilder<I, O> parser) : super(parser);

  @override
  void build(Context context, CodeGen code) {
    helper.build(context, code, parser,
        pos: code.pos, result: code.result, silent: true);
  }
}
