part of '../../combinator.dart';

class Not<I> extends ParserBuilder<I, void> {
  final ParserBuilder<I, dynamic> parser;

  const Not(this.parser);

  @override
  void build(Context context, CodeGen code) {
    final pos = code.savePos();
    helper.build(context, code, parser, fast: true, silent: true, pos: pos);
    code.negateState();
    code.ifFailure((code) {
      code.setPos(pos);
      code.setError('ErrUnknown(state.pos)');
    });
  }
}
