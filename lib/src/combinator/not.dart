part of '../../combinator.dart';

class Not<I> extends ParserBuilder<I, void> {
  final ParserBuilder<I, dynamic> parser;

  const Not(this.parser);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final pos = context.allocateLocal('pos');
    code + 'final $pos = state.pos;';
    helper.build(context, code, parser, true, true);
    code.negateState();
    code.ifFailure((code) {
      code + 'state.pos = $pos;';
      code += silent ? '' : 'state.error = ErrUnknown(state.pos);';
      code.labelFailure(result);
    }, else_: (code) {
      code.labelSuccess(result);
    });
  }
}
