part of '../../combinator.dart';

class Fast<I> extends ParserBuilder<I, void> {
  final ParserBuilder<I, dynamic> parser;

  const Fast(this.parser);

  @override
  void build(Context context, CodeGen code) {
    helper.build(context, code, parser, fast: true, pos: code.pos);
  }
}
