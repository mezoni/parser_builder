part of '../../multi.dart';

class Many0<I, O> extends ParserBuilder<I, List<O>> {
  final ParserBuilder<I, O> parser;

  const Many0(this.parser);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    if (parser.isAlwaysSuccess()) {
      throw StateError('Using a parser that always succeeds is not valid');
    }

    final key = BuidlResult();
    final fast = result.isVoid;
    final list = fast ? '' : context.allocateLocal('list');
    code += fast ? '' : 'final $list = <$O>[];';
    code.while$('true', (code) {
      final result1 = helper.getResult(context, code, parser, fast);
      helper.build(context, code, parser, result1, true, onSuccess: (code) {
        code += fast ? '' : '$list.add(${result1.valueUnsafe});';
      }, onFailure: (code) {
        code.break$();
      });
    });
    code.setSuccess();
    code.setResult(result, list);
    code.labelSuccess(key);
    return key;
  }

  @override
  bool isAlwaysSuccess() {
    return true;
  }
}
