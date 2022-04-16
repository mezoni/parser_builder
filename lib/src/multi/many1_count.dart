part of '../../multi.dart';

class Many1Count<I> extends ParserBuilder<I, int> {
  final ParserBuilder<I, dynamic> parser;

  const Many1Count(this.parser);

  @override
  void build(Context context, CodeGen code) {
    final count = code.local('var', 'count', '0', false);
    final ok = code.local('var', 'ok', 'false', true);
    code.while$('true', (code) {
      helper.build(context, code, parser, fast: true);
      code.ifSuccess((code) {
        code.addTo(count, 1, false);
        code.assign(ok, 'true', true);
      }, else_: (code) {
        code.break$();
      });
    });
    code.setState('$count != 0', false);
    code.setState(ok, true);
    code.ifSuccess((code) {
      code.setResult(count);
    });
  }
}
