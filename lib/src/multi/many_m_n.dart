part of '../../multi.dart';

class ManyMN<I, O> extends ParserBuilder<I, List<O>> {
  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
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

    final fast = result.isVoid;
    final count = context.allocateLocal('count');
    final pos = context.allocateLocal('pos');
    final list = fast ? '' : context.allocateLocal('list');
    code + 'final $pos = state.pos;';
    code += fast ? '' : 'final $list = <$O>[];';
    code + 'var $count = 0;';
    code.while$('$count < $n', (code) {
      final r1 =
          helper.build(context, code, parser, silent ? true : m == 0, fast);
      code.ifChildFailure(r1, (code) {
        code.break$();
      });
      code.onChildSuccess(r1, (code) {
        code += fast ? '' : '$list.add(${r1.value});';
        code + '$count++;';
      });
    });
    code.setState('$count >= $m');
    code.ifSuccess((code) {
      code.setResult(result, list);
      code.labelSuccess(result);
    }, else_: (code) {
      code + 'state.pos = $pos;';
      code.labelFailure(result);
    });
  }

  final int m;

  final int n;

  final ParserBuilder<I, O> parser;

  const ManyMN(this.m, this.n, this.parser);
}
