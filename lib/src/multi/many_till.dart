part of '../../multi.dart';

class ManyTill<I, O1, O2> extends ParserBuilder<I, tuple.Tuple2<List<O1>, O2>> {
  final ParserBuilder<I, O2> end;

  final ParserBuilder<I, O1> parser;

  const ManyTill(this.parser, this.end);

  @override
  void build(Context context, CodeGen code) {
    final pos = code.savePos();
    final list = code.val('list', '<$O1>[]', false);
    code.while$('true', (code) {
      final result1 = helper.build(context, code, end);
      code.ifSuccess((code) {
        code.setResult('Tuple2($list, ${result1.value})');
        code.break$();
      }, else_: (code) {
        var error = '';
        if (!code.silent) {
          error = code.val('error', 'state.error');
        }

        final result2 = helper.build(context, code, parser);
        code.ifSuccess((code) {
          code.add('$list.add(${result2.value});');
        }, else_: (code) {
          code.setError('ErrCombined(state.pos, [$error, state.error])');
          code.setPos(pos);
          code.break$();
        });
      });
    });
  }
}
