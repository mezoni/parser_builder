part of '../../multi.dart';

class SeparatedList1<I, O> extends ParserBuilder<I, List<O>> {
  final ParserBuilder<I, O> parser;

  final ParserBuilder<I, dynamic> separator;

  const SeparatedList1(this.parser, this.separator);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    if (parser.isAlwaysSuccess() && separator.isAlwaysSuccess()) {
      throw StateError('Using a parsers that always succeeds is not valid');
    }

    final key = BuidlResult();
    final fast = result.isVoid;
    final list = fast ? '' : context.allocateLocal('list');
    final ok = !fast ? '' : context.allocateLocal('ok');
    final pos = context.allocateLocal('pos');
    code + 'var $pos = state.pos;';
    code += fast ? 'var $ok = false;' : 'final $list = <$O>[];';
    code.while$('true', (code) {
      final result1 = helper.getResult(context, code, parser, fast);
      helper.build(context, code, parser, result1, silent, onSuccess: (code) {
        code += fast ? '$ok = true;' : '$list.add(${result1.valueUnsafe});';
      }, onFailure: (code) {
        code + 'state.pos = $pos;';
        code.break$();
      });
      code + '$pos = state.pos;';
      final result2 = helper.getResult(context, code, separator, true);
      helper.build(context, code, separator, result2, true, onFailure: (code) {
        code.break$();
      });
    });
    code.setState(fast ? ok : '$list.isNotEmpty');
    code.ifSuccess((code) {
      code.setResult(result, list);
      code.labelSuccess(key);
    }, else_: (code) {
      code.labelFailure(key);
    });
    return key;
  }
}
