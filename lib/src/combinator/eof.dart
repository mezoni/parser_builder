part of '../../combinator.dart';

class Eof<I> extends ParserBuilder<I, void> {
  const Eof();

  @override
  void build(Context context, CodeGen code) {
    context.refersToStateSource = true;
    code.setStateToEof();
    code.ifFailure((code) {
      code.setError('ErrExpected.eof(state.pos)');
    });
  }
}
