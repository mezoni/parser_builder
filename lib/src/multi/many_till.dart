part of '../../multi.dart';

class ManyTill<I, O1, O2> extends ParserBuilder<I, tuple.Tuple2<List<O1>, O2>> {
  final ParserBuilder<I, O2> end;

  final ParserBuilder<I, O1> parser;

  const ManyTill(this.parser, this.end);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    if (parser.isAlwaysSuccess() && end.isAlwaysSuccess()) {
      throw StateError('Using a parsers that always succeeds is not valid');
    }

    final key = BuidlResult();
    final fast = result.isVoid;
    final error = silent ? '' : context.allocateLocal('error');
    final list = fast ? '' : context.allocateLocal('list');
    final pos = context.allocateLocal('pos');
    code + 'final $pos = state.pos;';
    code += fast ? '' : 'final $list = <$O1>[];';
    code.while$('true', (code) {
      final result1 = helper.getResult(context, code, end, fast);
      helper.build(context, code, end, result1, silent, onSuccess: (code) {
        code.setResult(result, 'Tuple2($list, ${result1.value})');
        code.break$();
      }, onFailure: (code) {
        code += silent ? '' : 'final $error = state.error;';
        final result2 = helper.getResult(context, code, parser, fast);
        helper.build(context, code, parser, result2, silent, onSuccess: (code) {
          code += fast ? '' : '$list.add(${result2.valueUnsafe});';
        }, onFailure: (code) {
          code += silent
              ? ''
              : 'state.error = ErrCombined(state.pos, [$error, state.error]);';
          code + 'state.pos = $pos;';
          code.break$();
        });
      });
    });
    return key;
  }
}
