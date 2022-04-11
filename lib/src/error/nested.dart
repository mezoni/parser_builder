part of '../../error.dart';

class Nested<I, O> extends ParserBuilder<I, O> {
  final String message;

  final ParserBuilder<I, O> parser;

  final String tag;

  const Nested(this.message, this.tag, this.parser);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final fast = result.isVoid;
    final message = helper.escapeString(this.message);
    final pos = context.allocateLocal('pos');
    final tag = helper.escapeString(this.tag);
    code + 'final $pos = state.pos;';
    final r1 = helper.build(context, code, parser, silent, fast);
    code.ifChildSuccess(r1, (code) {
      code.setResult(result, r1.name, false);
      code.labelSuccess(result);
    }, else_: (code) {
      code += silent
          ? ''
          : 'state.error = ErrNested($pos, $message, const Tag($tag), state.error);';
      code.labelFailure(result);
    });
  }
}
