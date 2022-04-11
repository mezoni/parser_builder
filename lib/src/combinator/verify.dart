part of '../../combinator.dart';

class Verify<I, O> extends ParserBuilder<I, O> {
  final String message;

  final ParserBuilder<I, O> parser;

  final SemanticAction<bool> verify;

  const Verify(this.message, this.parser, this.verify);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final message = helper.escapeString(this.message);
    final pos = context.allocateLocal('pos');
    final verify = this.verify.build(context, 'verify', ['v']);
    code + 'final $pos = state.pos;';
    final r1 = helper.build(context, code, parser, silent, false);
    code.ifChildSuccess(r1, (code) {
      code + 'final v = ${r1.value};';
      code.setState(verify);
      code.ifSuccess((code) {
        code.setResult(result, r1.name);
        code.labelSuccess(result);
      }, else_: (code) {
        code += silent
            ? ''
            : 'state.error = ErrMessage($pos, state.pos - $pos, $message);';
        code += silent ? '' : 'state.error.failure = state.pos;';
      });
    });
  }
}
