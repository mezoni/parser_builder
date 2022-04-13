part of '../../combinator.dart';

class Eof<I> extends ParserBuilder<I, void> {
  const Eof();

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final key = BuidlResult();
    code.setState('state.pos >= state.source.length');
    code.ifFailure((code) {
      code += silent ? '' : 'state.error = ErrExpected.eof(state.pos);';
      code.labelFailure(key);
    }, else_: (code) {
      code.labelSuccess(key);
    });
    return key;
  }
}
