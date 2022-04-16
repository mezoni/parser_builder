part of '../../multi.dart';

class ManyMN<I, O> extends ParserBuilder<I, List<O>> {
  final int m;

  final int n;

  final ParserBuilder<I, O> parser;

  const ManyMN(this.m, this.n, this.parser);

  @override
  void build(Context context, CodeGen code) {
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

    final pos = code.savePos();
    final list = code.val('list', '<$O>[]', false);
    final count = code.local('var', 'count', '0');
    code.while$('$count < $n', (code) {
      final silent = code.silent ? true : m == 0;
      final result = helper.build(context, code, parser, silent: silent);
      code.ifSuccess((code) {
        code.add('$list.add(${result.value});', false);
        code.addTo(count, 1);
      }, else_: (code) {
        code.break$();
      });
    });
    code.setState('$count >= $m');
    code.ifSuccess((code) {
      code.setResult(list);
    }, else_: (code) {
      code.setPos(pos);
    });
  }
}
