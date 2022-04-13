part of '../../multi.dart';

class Many0Count<I> extends ParserBuilder<I, int> {
  final ParserBuilder<I, dynamic> parser;

  const Many0Count(this.parser);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    if (parser.isAlwaysSuccess()) {
      throw StateError('Using a parser that always succeeds is not valid');
    }

    final key = BuidlResult();
    final fast = result.isVoid;
    final count = fast ? '' : context.allocateLocal('count');
    code += fast ? '' : 'var $count = 0;';
    code.while$('true', (code) {
      final result1 = helper.getResult(context, code, parser, true);
      helper.build(context, code, parser, result1, true, onSuccess: (code) {
        code += fast ? '' : '$count++;';
      }, onFailure: (code) {
        code.break$();
      });
    });
    code.setSuccess();
    code.setResult(result, count);
    code.labelSuccess(key);
    return key;
  }

  @override
  bool isAlwaysSuccess() {
    return true;
  }
}
