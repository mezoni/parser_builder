part of '../../combinator.dart';

class Eof<I> extends ParserBuilder<I, void> {
  const Eof();

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    code.setState('state.pos >= state.source.length');
    code.ifFailure((code) {
      code += silent ? '' : 'state.error = ErrExpected.eof(state.pos);';
      code.labelFailure(result);
    }, else_: (code) {
      code.labelSuccess(result);
    });
  }
}
