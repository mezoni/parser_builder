part of '../../error.dart';

class ExpectedChar extends StringParserBuilder<int> {
  final int char;

  final ParserBuilder<String, int> parser;

  const ExpectedChar(this.parser, this.char);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final key = BuidlResult();
    final pos = context.allocateLocal('pos');
    code + 'final $pos = state.pos;';
    final result1 = helper.getResult(context, code, parser, false);
    helper.build(context, code, parser, result1, silent, onSuccess: (code) {
      // TODO if fast then unsafe
      code.setState('${result1.value} == $char');
      code.ifSuccess((code) {
        code.setResult(result, result1.name, false);
      });
    });
    code.ifFailure((code) {
      code + 'state.pos = $pos;';
      code += silent
          ? ''
          : 'state.error = ErrExpected.char(state.pos, const Char($char));';
      code.labelFailure(key);
    }, else_: (code) {
      code.labelSuccess(key);
    });
    return key;
  }

  @override
  bool isAlwaysSuccess() {
    return parser.isAlwaysSuccess();
  }
}
