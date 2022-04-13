part of '../../multi.dart';

class FoldMany0<I, O> extends ParserBuilder<I, O> {
  final SemanticAction<O> combine;

  final SemanticAction<O> initialize;

  final ParserBuilder<I, O> parser;

  const FoldMany0(this.parser, this.initialize, this.combine);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    if (parser.isAlwaysSuccess()) {
      throw StateError('Using a parser that always succeeds is not valid');
    }

    final key = BuidlResult();
    final fast = result.isVoid;
    final acc = fast ? '' : context.allocateLocal('acc');
    final v = fast ? '' : context.allocateLocal('v');
    final combine =
        fast ? '' : this.combine.build(context, 'combine', [acc, v]);
    final initialize =
        fast ? '' : this.initialize.build(context, 'initialize', []);
    code += fast ? '' : 'var $acc = $initialize;';
    code.while$('true', (code) {
      final result1 = helper.getResult(context, code, parser, fast);
      helper.build(context, code, parser, result1, true, onSuccess: (code) {
        code += fast ? '' : 'final $v = ${result1.value};';
        code += fast ? '' : '$combine;';
      }, onFailure: (code) {
        code.break$();
      });
    });
    code.setSuccess();
    code.setResult(result, acc);
    code.labelSuccess(key);
    return key;
  }

  @override
  bool isAlwaysSuccess() {
    return true;
  }
}
