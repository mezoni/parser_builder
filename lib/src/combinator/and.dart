part of '../../combinator.dart';

class And<I> extends ParserBuilder<I, void> {
  final ParserBuilder<I, dynamic> parser;

  const And(this.parser);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final pos = context.allocateLocal('pos');
    code + 'final $pos = state.pos;';
    final r1 = helper.build(context, code, parser, true, true);
    code.ifChildSuccess(r1, (code) {
      code + 'state.pos = $pos;';
      code.labelSuccess(result);
    }, else_: (code) {
      code += silent ? '' : 'state.error = ErrUnknown(state.pos);';
      code.labelFailure(result);
    });
  }
}
