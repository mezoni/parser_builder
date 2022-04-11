part of '../../error.dart';

class Expected<I, O> extends ParserBuilder<I, O> {
  final ParserBuilder<I, O> parser;

  final String tag;

  const Expected(this.tag, this.parser);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final fast = result.isVoid;
    final tag = helper.escapeString(this.tag);
    final r1 = helper.build(context, code, parser, silent, fast);
    code.ifChildSuccess(r1, (code) {
      code.setResult(result, r1.name, false);
      code.labelSuccess(result);
    }, else_: (code) {
      code += silent
          ? ''
          : 'state.error = ErrExpected.tag(state.pos, const Tag($tag));';
      code.labelFailure(result);
    });
  }
}
