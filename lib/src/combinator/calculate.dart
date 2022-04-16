part of '../../combinator.dart';

class Calculate<I, O> extends ParserBuilder<I, O> {
  final SemanticAction<O> calculate;

  const Calculate(this.calculate);

  @override
  void build(Context context, CodeGen code) {
    code.setSuccess();
    code.setResult(calculate.build(context, 'calculate', []));
  }
}
