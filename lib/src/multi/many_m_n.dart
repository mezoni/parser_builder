part of '../../multi.dart';

class ManyMN<I, O> extends ParserBuilder<I, List<O>> {
  final int m;

  final int n;

  final ParserBuilder<I, O> parser;

  const ManyMN(this.m, this.n, this.parser);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    if (m < 0) {
      throw RangeError.value(m, 'm', 'Must be equal to or greater than 0');
    }

    if (n < m) {
      throw RangeError.value(
          n, 'n', 'Must be equal to or greater than \'m\' ($m)');
    }

    if (n == 0) {
      throw RangeError.value(n, 'n', 'Must be greater than 0');
    }

    final key = BuidlResult();
    final fast = result.isVoid;
    final count = context.allocateLocal('count');
    final pos = context.allocateLocal('pos');
    final list = fast ? '' : context.allocateLocal('list');
    code + 'final $pos = state.pos;';
    code += fast ? '' : 'final $list = <$O>[];';
    code + 'var $count = 0;';
    code.while$('$count < $n', (code) {
      final silent1 = silent ? true : m == 0;
      final result1 = helper.getResult(context, code, parser, fast);
      helper.build(context, code, parser, result1, silent1, onSuccess: (code) {
        code += fast ? '' : '$list.add(${result1.valueUnsafe});';
        code + '$count++;';
      }, onFailure: (code) {
        code.break$();
      });
    });
    code.setState('$count >= $m');
    code.ifSuccess((code) {
      code.setResult(result, list);
      code.labelSuccess(key);
    }, else_: (code) {
      code + 'state.pos = $pos;';
      code.labelFailure(key);
    });
    return key;
  }

  @override
  bool isAlwaysSuccess() {
    return m == 0;
  }
}
