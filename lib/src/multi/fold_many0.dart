part of '../../multi.dart';

class FoldMany0<I, O> extends ParserBuilder<I, O> {
  final SemanticAction<O> combine;

  final SemanticAction<O> initialize;

  final ParserBuilder<I, O> parser;

  const FoldMany0(this.parser, this.initialize, this.combine);

  @override
  void build(Context context, CodeGen code) {
    final acc = code.local(
        'var', 'acc', initialize.build(context, 'initialize', []), false);
    code.while$('true', (code) {
      final result = helper.build(context, code, parser, silent: true);
      code.ifSuccess((code) {
        final v = code.val('v', result.value, false);
        code.add(combine.build(context, 'combine', [acc, v]) + ';', false);
      }, else_: (code) {
        code.break$();
      });
    });

    code.setSuccess();
    code.setResult(acc);
  }
}
