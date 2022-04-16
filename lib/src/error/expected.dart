part of '../../error.dart';

class Expected<I, O> extends ParserBuilder<I, O> {
  final ParserBuilder<I, O> parser;

  final String tag;

  const Expected(this.tag, this.parser);

  @override
  void build(Context context, CodeGen code) {
    final tag = helper.escapeString(this.tag);
    helper.build(context, code, parser, result: code.result, silent: true);
    code.ifFailure((code) {
      code.setError('ErrExpected.tag(state.pos, const Tag($tag))');
    });
  }
}
