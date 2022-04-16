part of '../../error.dart';

class Nested<I, O> extends ParserBuilder<I, O> {
  final String message;

  final ParserBuilder<I, O> parser;

  final String tag;

  const Nested(this.message, this.tag, this.parser);

  @override
  void build(Context context, CodeGen code) {
    final message = helper.escapeString(this.message);
    final tag = helper.escapeString(this.tag);
    final pos = code.savePos();
    helper.build(context, code, parser, pos: pos, result: code.result);
    code.ifFailure((code) {
      code.setError('ErrNested($pos, $message, const Tag($tag), state.error)');
    });
  }
}
