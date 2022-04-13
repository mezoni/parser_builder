part of '../../combinator.dart';

class Verify<I, O> extends ParserBuilder<I, O> {
  final String message;

  final ParserBuilder<I, O> parser;

  final SemanticAction<bool> verify;

  const Verify(this.message, this.parser, this.verify);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final key = BuidlResult();
    final message = helper.escapeString(this.message);
    final pos = context.allocateLocal('pos');
    final v = context.allocateLocal('v');
    final verify = this.verify.build(context, 'verify', [v]);
    code + 'final $pos = state.pos;';
    final result1 = helper.getNotVoidResult(context, code, parser, result);
    helper.build(context, code, parser, result1, silent, onSuccess: (code) {
      code + 'final $v = ${result1.value};';
      code.setState(verify);
      code.ifFailure((code) {
        code += silent
            ? ''
            : 'state.error = ErrMessage($pos, state.pos - $pos, $message);';
        code += silent ? '' : 'state.error.failure = state.pos;';
      }, else_: (code) {
        code.labelSuccess(key);
      });
    });
    return key;
  }
}
