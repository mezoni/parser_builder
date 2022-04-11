part of '../../combinator.dart';

class Consumed<I, O> extends ParserBuilder<I, tuple.Tuple2<I, O>> {
  final ParserBuilder<I, O> parser;

  const Consumed(this.parser);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final fast = result.isVoid;
    final pos = fast ? '' : context.allocateLocal('pos');
    code += fast ? '' : 'final $pos = state.pos;';
    final r1 = helper.build(context, code, parser, silent, false);
    code.ifChildSuccess(r1, (code) {
      code += fast ? '' : 'final v = state.source.slice($pos, state.pos);';
      code.setResult(result, 'Tuple2(v, ${r1.value})');
      code.labelSuccess(result);
    }, else_: (code) {
      code.labelFailure(result);
    });
  }
}
