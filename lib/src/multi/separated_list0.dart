part of '../../multi.dart';

class SeparatedList0<I, O> extends ParserBuilder<I, List<O>> {
  final ParserBuilder<I, O> parser;

  final ParserBuilder<I, dynamic> separator;

  const SeparatedList0(this.parser, this.separator);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final fast = result.isVoid;
    final list = fast ? '' : context.allocateLocal('list');
    final pos = context.allocateLocal('pos');
    code + 'var $pos = state.pos;';
    code += fast ? '' : 'final $list = <$O>[];';
    code.iteration('for(;;)', (code) {
      final r1 = helper.build(context, code, parser, true, fast);
      code.ifChildFailure(r1, (code) {
        code + 'state.pos = $pos;';
        code.break$();
      });
      code.onChildSuccess(r1, (code) {
        code += fast ? '' : '$list.add(${r1.value});';
      });
      code + '$pos = state.pos;';
      final r2 = helper.build(context, code, separator, true, true);
      code.ifChildFailure(r2, (code) {
        code.break$();
      });
    });
    code.setSuccess();
    code.setResult(result, list);
    code.labelSuccess(result);
  }
}
