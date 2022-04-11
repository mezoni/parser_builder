part of '../../multi.dart';

class Many1<I, O> extends ParserBuilder<I, List<O>> {
  final ParserBuilder<I, O> parser;

  const Many1(this.parser);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final fast = result.isVoid;
    final list = fast ? '' : context.allocateLocal('list');
    final ok = !fast ? '' : context.allocateLocal('ok');
    code += fast ? 'var $ok = false;' : 'final $list = <$O>[];';
    code.while$('true', (code) {
      final r1 = helper.build(context, code, parser, silent, fast);
      code.ifChildFailure(r1, (code) {
        code.break$();
      });
      code.onChildSuccess(r1, (code) {
        code += fast ? '$ok = true;' : '$list.add(${r1.value});';
      });
    });
    code.setState(fast ? ok : '$list.isNotEmpty');
    code.ifSuccess((code) {
      code.setResult(result, list);
      code.labelSuccess(result);
    }, else_: (code) {
      code.labelFailure(result);
    });
  }
}
