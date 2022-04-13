part of '../../combinator.dart';

class And<I> extends ParserBuilder<I, void> {
  final ParserBuilder<I, dynamic> parser;

  const And(this.parser);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final key = BuidlResult();
    final pos = context.allocateLocal('pos');
    code + 'final $pos = state.pos;';
    final result1 = helper.getResult(context, code, parser, true);
    helper.build(context, code, parser, result1, true, onSuccess: (code) {
      code + 'state.pos = $pos;';
      code.labelSuccess(key);
    }, onFailure: (code) {
      code += silent ? '' : 'state.error = ErrUnknown(state.pos);';
      code.labelFailure(key);
    });
    return key;
  }

  @override
  bool isAlwaysSuccess() {
    return parser.isAlwaysSuccess();
  }
}
