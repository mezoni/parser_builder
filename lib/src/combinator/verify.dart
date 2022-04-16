part of '../../combinator.dart';

class Verify<I, O> extends ParserBuilder<I, O> {
  final String message;

  final ParserBuilder<I, O> parser;

  final SemanticAction<bool> verify;

  const Verify(this.message, this.parser, this.verify);

  @override
  void build(Context context, CodeGen code) {
    final pos = code.savePos();
    final result = helper.build(context, code, parser,
        fast: false, result: code.result, pos: pos);
    code.ifSuccess((code) {
      final v = code.val('v', result.value);
      code.setState(verify.build(context, 'verify', [v]));
      code.ifFailure((code) {
        final message = helper.escapeString(this.message);
        code.setError(
            'ErrMessage($pos, state.pos - $pos, $message)..failure = state.pos');
        code.setPos(pos);
      });
    });
  }
}
