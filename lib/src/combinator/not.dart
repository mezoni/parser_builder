part of '../../combinator.dart';

class Not<I> extends ParserBuilder<I, void> {
  final ParserBuilder<I, dynamic> parser;

  const Not(this.parser);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final key = BuidlResult();
    final pos = context.allocateLocal('pos');
    code + 'final $pos = state.pos;';
    final result1 = helper.getResult(context, code, parser, true);
    helper.build(context, code, parser, result1, true);
    code.negateState();
    code.ifFailure((code) {
      code + 'state.pos = $pos;';
      code += silent ? '' : 'state.error = ErrUnknown(state.pos);';
      code.labelFailure(key);
    }, else_: (code) {
      code.labelSuccess(key);
    });
    return key;
  }
}
