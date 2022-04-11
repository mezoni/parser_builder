part of '../../combinator.dart';

class MoveTo<I> extends ParserBuilder<I, int> {
  final ParserBuilder<I, int> position;

  const MoveTo(this.position);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    context.refersToStateSource = true;
    final r1 = helper.build(context, code, position, silent, false);
    code.ifChildSuccess(r1, (code) {
      code + 'final v = ${r1.value};';
      code.setState('v <= source.length');
      code.ifSuccess((code) {
        code + 'state.pos = v;';
        code.labelSuccess(result);
      }, else_: (code) {
        code += silent ? '' : 'state.error = ErrUnexpected.eof(v);';
      });
    });
  }
}
