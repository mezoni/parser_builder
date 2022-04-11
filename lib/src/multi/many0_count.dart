part of '../../multi.dart';

class Many0Count<I> extends ParserBuilder<I, int> {
  final ParserBuilder<I, dynamic> parser;

  const Many0Count(this.parser);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final fast = result.isVoid;
    final count = fast ? '' : context.allocateLocal('count');
    code += fast ? '' : 'var $count = 0;';
    code.while$('true', (code) {
      final r1 = helper.build(context, code, parser, true, true);
      code.ifChildFailure(r1, (code) {
        code.break$();
      });
      code.onChildSuccess(r1, (code) {
        code += fast ? '' : '$count++;';
      });
    });
    code.setSuccess();
    code.setResult(result, count);
    code.labelSuccess(result);
  }
}
