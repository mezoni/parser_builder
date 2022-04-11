part of '../../multi.dart';

class FoldMany0<I, O> extends ParserBuilder<I, O> {
  final SemanticAction<O> combine;

  final SemanticAction<O> initialize;

  final ParserBuilder<I, O> parser;

  const FoldMany0(this.parser, this.initialize, this.combine);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final fast = result.isVoid;
    final acc = fast ? '' : context.allocateLocal('acc');
    final combine =
        fast ? '' : this.combine.build(context, 'combine', [acc, 'v']);
    final initialize =
        fast ? '' : this.initialize.build(context, 'initialize', []);
    code += fast ? '' : 'var $acc = $initialize;';
    code.iteration('for (;;)', (code) {
      final r1 = helper.build(context, code, parser, true, fast);
      code.ifChildFailure(r1, (code) {
        code.break$();
      });
      code.onChildSuccess(r1, (code) {
        code += fast ? '' : 'final v = ${r1.value};';
        code += fast ? '' : '$combine;';
      });
    });
    code.setSuccess();
    code.setResult(result, acc);
    code.labelSuccess(result);
  }
}
