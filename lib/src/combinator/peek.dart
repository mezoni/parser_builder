part of '../../combinator.dart';

class Peek<I, O> extends ParserBuilder<I, O> {
  final ParserBuilder<I, O> parser;

  const Peek(this.parser);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final fast = result.isVoid;
    final pos = context.allocateLocal('pos');
    code + 'final $pos = state.pos;';
    final r1 = helper.build(context, code, parser, silent, fast);
    code.ifChildSuccess(r1, (code) {
      code + 'state.pos = $pos;';
      code.setResult(result, r1.name, false);
      code.labelSuccess(result);
    }, else_: (code) {
      code.labelFailure(result);
    });
  }
}
