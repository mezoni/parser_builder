part of '../../multi.dart';

class Many1Count<I> extends ParserBuilder<I, int> {
  final ParserBuilder<I, dynamic> parser;

  const Many1Count(this.parser);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    if (parser.isAlwaysSuccess()) {
      throw StateError('Using a parser that always succeeds is not valid');
    }

    final key = BuidlResult();
    final fast = result.isVoid;
    final count = fast ? '' : context.allocateLocal('count');
    final ok = !fast ? '' : context.allocateLocal('ok');
    code += fast ? 'var $ok = false;' : 'var $count = 0;';
    code.while$('true', (code) {
      final result1 = helper.getResult(context, code, parser, true);
      helper.build(context, code, parser, result1, silent, onSuccess: (code) {
        code += fast ? '$ok = true;' : '$count++;';
      }, onFailure: (code) {
        code.break$();
      });
    });
    code.setState(fast ? ok : '$count != 0');
    code.ifSuccess((code) {
      code.setResult(result, count);
      code.labelSuccess(key);
    }, else_: (code) {
      code.labelFailure(key);
    });
    return key;
  }
}
