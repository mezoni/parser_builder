part of '../../combinator.dart';

class Recognize<I> extends ParserBuilder<I, I> {
  final ParserBuilder<I, dynamic> parser;

  const Recognize(this.parser);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final key = BuidlResult();
    final fast = result.isVoid;
    final pos = fast ? '' : context.allocateLocal('pos');
    code += fast ? '' : 'final $pos = state.pos;';
    final result1 = helper.getResult(context, code, parser, true);
    helper.build(context, code, parser, result1, silent, onSuccess: (code) {
      code.setResult(result, 'state.source.slice($pos, state.pos)');
      code.labelSuccess(key);
    }, onFailure: (code) {
      code.labelFailure(key);
    });
    return key;
  }

  @override
  bool isAlwaysSuccess() {
    return parser.isAlwaysSuccess();
  }
}
