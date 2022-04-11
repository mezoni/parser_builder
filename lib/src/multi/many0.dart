part of '../../multi.dart';

class Many0<I, O> extends ParserBuilder<I, List<O>> {
  final ParserBuilder<I, O> parser;

  const Many0(this.parser);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final fast = result.isVoid;
    final list = fast ? '' : context.allocateLocal('list');
    code += fast ? '' : 'final $list = <$O>[];';
    code.while$('true', (code) {
      final r1 = helper.build(context, code, parser, true, fast);
      code.ifChildFailure(r1, (code) {
        code.break$();
      });
      code.onChildSuccess(r1, (code) {
        code += fast ? '' : '$list.add(${r1.value});';
      });
    });
    code.setSuccess();
    code.setResult(result, list);
    code.labelSuccess(result);
  }
}
