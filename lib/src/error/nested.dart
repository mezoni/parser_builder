part of '../../error.dart';

class Nested<I, O> extends ParserBuilder<I, O> {
  final String message;

  final ParserBuilder<I, O> parser;

  final String tag;

  const Nested(this.message, this.tag, this.parser);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final key = BuidlResult();
    final message = helper.escapeString(this.message);
    final pos = context.allocateLocal('pos');
    final tag = helper.escapeString(this.tag);
    code + 'final $pos = state.pos;';
    helper.build(context, code, parser, result, silent, onSuccess: (code) {
      code.labelSuccess(key);
    }, onFailure: (code) {
      code += silent
          ? ''
          : 'state.error = ErrNested($pos, $message, const Tag($tag), state.error);';
      code.labelFailure(key);
    });
    return key;
  }
}
