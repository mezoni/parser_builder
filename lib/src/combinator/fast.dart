part of '../../combinator.dart';

class Fast<I> extends ParserBuilder<I, void> {
  final ParserBuilder<I, dynamic> parser;

  const Fast(this.parser);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    helper.build(context, code, parser, silent, true);
  }
}
