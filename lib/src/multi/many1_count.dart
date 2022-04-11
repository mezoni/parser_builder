part of '../../multi.dart';

class Many1Count<I> extends ParserBuilder<I, int> {
  final ParserBuilder<I, dynamic> parser;

  const Many1Count(this.parser);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final fast = result.isVoid;
    final count = fast ? '' : context.allocateLocal('count');
    final ok = !fast ? '' : context.allocateLocal('ok');
    code += fast ? 'var $ok = false;' : 'var $count = 0;';
    code.while$('true', (code) {
      final r1 = helper.build(context, code, parser, silent, true);
      code.ifChildFailure(r1, (code) {
        code.break$();
      });
      code.onChildSuccess(r1, (code) {
        code += fast ? '$ok = true;' : '$count++;';
      });
    });
    code.setState(fast ? ok : '$count != 0');
    code.ifSuccess((code) {
      code.setResult(result, count);
      code.labelSuccess(result);
    }, else_: (code) {
      code.labelFailure(result);
    });
  }
}
