part of '../../combinator.dart';

class Recognize<I> extends ParserBuilder<I, I> {
  final ParserBuilder<I, dynamic> parser;

  const Recognize(this.parser);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final fast = result.isVoid;
    final pos = fast ? '' : context.allocateLocal('pos');
    code += fast ? '' : 'final $pos = state.pos;';
    final r1 = helper.build(context, code, parser, silent, true);
    code.ifChildSuccess(r1, (code) {
      code.setResult(result, 'state.source.slice($pos, state.pos)');
      code.labelSuccess(result);
    }, else_: (code) {
      code.labelFailure(result);
    });
  }
}
