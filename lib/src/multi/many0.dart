part of '../../multi.dart';

class Many0<I, O> extends ParserBuilder<I, List<O>> {
  final ParserBuilder<I, O> parser;

  const Many0(this.parser);

  @override
  void build(Context context, CodeGen code) {
    final list = code.val('list', '<$O>[]', false);
    code.while$('true', (code) {
      final result = helper.build(context, code, parser, silent: true);
      code.ifSuccess((code) {
        code.add('$list.add(${result.value});', false);
      }, else_: (code) {
        code.break$();
      });
    });
    code.setSuccess();
    code.setResult(list);
  }
}
