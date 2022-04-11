part of '../../multi.dart';

class ManyTill<I, O1, O2> extends ParserBuilder<I, tuple.Tuple2<List<O1>, O2>> {
  final ParserBuilder<I, O2> end;

  final ParserBuilder<I, O1> parser;

  const ManyTill(this.parser, this.end);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final fast = result.isVoid;
    final error = silent ? '' : context.allocateLocal('error');
    final list = fast ? '' : context.allocateLocal('list');
    final pos = context.allocateLocal('pos');
    code + 'final $pos = state.pos;';
    code += fast ? '' : 'final $list = <$O1>[];';
    code.while$('true', (code) {
      final r1 = helper.build(context, code, end, silent, fast);
      code.ifChildSuccess(r1, (code) {
        code.setResult(result, 'Tuple2($list, ${r1.value})');
        code.break$();
      });
      code += silent ? '' : 'final $error = state.error;';
      final r2 = helper.build(context, code, parser, silent, fast);
      code.ifChildFailure(r2, (code) {
        code += silent
            ? ''
            : 'state.error = ErrCombined(state.pos, [$error, state.error]);';
        code + 'state.pos = $pos;';
        code.break$();
      });
      code.onChildSuccess(r2, (code) {
        code += fast ? '' : '$list.add(${r2.value});';
      });
    });
  }
}
