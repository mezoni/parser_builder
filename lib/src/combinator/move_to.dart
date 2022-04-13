part of '../../combinator.dart';

class MoveTo<I> extends ParserBuilder<I, int> {
  final ParserBuilder<I, int> position;

  const MoveTo(this.position);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    context.refersToStateSource = true;
    final key = BuidlResult();
    final pos = context.allocateLocal('pos');
    final result1 = helper.getNotVoidResult(context, code, position, result);
    helper.build(context, code, position, result1, silent, onSuccess: (code) {
      code + 'final $pos = ${result1.value};';
      code.setState('$pos <= source.length');
      code.ifSuccess((code) {
        code + 'state.pos = $pos;';
        code.setResult(result, pos);
        code.labelSuccess(key);
      }, else_: (code) {
        code += silent ? '' : 'state.error = ErrUnexpected.eof($pos);';
      });
    });
    return key;
  }
}
