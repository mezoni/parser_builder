part of '../../multi.dart';

class Many1<I, O> extends ParserBuilder<I, List<O>> {
  final ParserBuilder<I, O> parser;

  const Many1(this.parser);

  @override
  void build(Context context, CodeGen code) {
    final list = code.val('list', '<$O>[]', false);
    final ok = code.local('var', 'ok', 'false', true);
    code.while$('true', (code) {
      final result = helper.build(context, code, parser);
      code.ifSuccess((code) {
        code.add('$list.add(${result.value});', false);
        code.assign(ok, 'true', true);
      }, else_: (code) {
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
