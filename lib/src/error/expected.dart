part of '../../error.dart';

class Expected<I, O> extends ParserBuilder<I, O> {
  final ParserBuilder<I, O> parser;

  final String tag;

  const Expected(this.tag, this.parser);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final key = BuidlResult();
    final tag = helper.escapeString(this.tag);
    helper.build(context, code, parser, result, silent, onSuccess: (code) {
      code.labelSuccess(key);
    }, onFailure: (code) {
      code += silent
          ? ''
          : 'state.error = ErrExpected.tag(state.pos, const Tag($tag));';
      code.labelFailure(key);
    });
    return key;
  }
}
