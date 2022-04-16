part of '../../combinator.dart';

class Peek<I, O> extends UnaryParserBuilder<I, O> {
  const Peek(ParserBuilder<I, O> parser) : super(parser);

  @override
  void build(Context context, CodeGen code) {
    final pos = code.savePos();
    helper.build(context, code, parser, result: code.result, pos: pos);
    code.ifSuccess((code) {
      code.setPos(pos);
    });
  }
}
