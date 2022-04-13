part of '../../combinator.dart';

class Peek<I, O> extends ParserBuilder<I, O> {
  final ParserBuilder<I, O> parser;

  const Peek(this.parser);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final key = BuidlResult();
    final pos = context.allocateLocal('pos');
    code + 'final $pos = state.pos;';
    helper.build(context, code, parser, result, silent, onSuccess: (code) {
      code + 'state.pos = $pos;';
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
