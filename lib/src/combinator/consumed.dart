part of '../../combinator.dart';

class Consumed<I, O> extends ParserBuilder<I, tuple.Tuple2<I, O>> {
  final ParserBuilder<I, O> parser;

  const Consumed(this.parser);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final key = BuidlResult();
    final fast = result.isVoid;
    final pos = fast ? '' : context.allocateLocal('pos');
    final v = fast ? '' : context.allocateLocal('v');
    code += fast ? '' : 'final $pos = state.pos;';
    final result1 = helper.getResult(context, code, parser, fast);
    helper.build(context, code, parser, result1, silent, onSuccess: (code) {
      code += fast ? '' : 'final $v = state.source.slice($pos, state.pos);';
      code.setResult(result, 'Tuple2($v, ${result1.value})');
      code.labelSuccess(key);
    }, onFailure: (code) {
      code.labelFailure(key);
    });
    return key;
  }

  @override
  bool isAlwaysSuccess() {
    return parser.isAlwaysSuccess();
  }
}
