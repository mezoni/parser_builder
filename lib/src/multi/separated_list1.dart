part of '../../multi.dart';

class SeparatedList1<I, O> extends ParserBuilder<I, List<O>> {
  final ParserBuilder<I, O> parser;

  final ParserBuilder<I, dynamic> separator;

  const SeparatedList1(this.parser, this.separator);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final fast = result.isVoid;
    final list = fast ? '' : context.allocateLocal('list');
    final ok = !fast ? '' : context.allocateLocal('ok');
    final pos = context.allocateLocal('pos');
    code + 'var $pos = state.pos;';
    code += fast ? 'var $ok = false;' : 'final $list = <$O>[];';
    code.iteration('for(;;)', (code) {
      final r1 = helper.build(context, code, parser, silent, fast);
      code.ifChildFailure(r1, (code) {
        code + 'state.pos = $pos;';
        code.break$();
      });
      code.onChildSuccess(r1, (code) {
        code += fast ? '$ok = true;' : '$list.add(${r1.value});';
      });
      code + '$pos = state.pos;';
      final r2 = helper.build(context, code, separator, silent, true);
      code.ifChildFailure(r2, (code) {
        code.break$();
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
