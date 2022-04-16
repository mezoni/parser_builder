part of '../../multi.dart';

class SeparatedList1<I, O> extends ParserBuilder<I, List<O>> {
  final ParserBuilder<I, O> parser;

  final ParserBuilder<I, dynamic> separator;

  const SeparatedList1(this.parser, this.separator);

  @override
  void build(Context context, CodeGen code) {
    final list = code.val('list', '<$O>[]', false);
    final ok = code.local('var', 'ok', 'false', true);
    final pos = code.local('var', 'pos', 'state.pos');
    code.while$('true', (code) {
      final result = helper.build(context, code, parser);
      code.ifSuccess((code) {
        code.add('$list.add(${result.value});', false);
        code.assign(ok, 'true', true);
      }, else_: (code) {
        code.setPos(pos);
        code.break$();
      });
      code.assign(pos, 'state.pos');
      helper.build(context, code, separator, fast: true, silent: true);
      code.ifFailure((code) {
        code.break$();
      });
    });
    code.setState('$list.isNotEmpty', false);
    code.setState(ok, true);
    code.ifSuccess((code) {
      code.setResult(list);
    });
  }
}
