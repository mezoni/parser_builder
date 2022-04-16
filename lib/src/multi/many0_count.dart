part of '../../multi.dart';

class Many0Count<I> extends ParserBuilder<I, int> {
  final ParserBuilder<I, dynamic> parser;

  const Many0Count(this.parser);

  @override
  void build(Context context, CodeGen code) {
    final count = code.local('var', 'count', '0', false);
    code.while$('true', (code) {
      helper.build(context, code, parser, fast: true, silent: true);
      code.ifSuccess((code) {
        code.addTo(count, 1, false);
      }, else_: (code) {
        code.break$();
      });
    });
    code.setSuccess();
    code.setResult(count);
  }
}
