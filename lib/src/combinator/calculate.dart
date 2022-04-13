part of '../../combinator.dart';

class Calculate<I, O> extends ParserBuilder<I, O> {
  final SemanticAction<O> calculate;

  const Calculate(this.calculate);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final key = BuidlResult();
    final calculate = this.calculate.build(context, 'calculate', []);
    final v = context.allocateLocal('v');
    code + 'final $v = $calculate;';
    code.setSuccess();
    code.setResult(result, v);
    code.labelSuccess(key);
    return key;
  }

  @override
  bool isAlwaysSuccess() {
    return true;
  }
}
