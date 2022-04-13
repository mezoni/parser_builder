part of '../../error.dart';

class UnexpectedCharOrEof extends StringParserBuilder<int> {
  final ParserBuilder<String, int> parser;

  final SemanticAction<bool> predicate;

  const UnexpectedCharOrEof(this.parser, this.predicate);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final key = BuidlResult();
    final fast = result.isVoid;
    final c = context.allocateLocal('c');
    final pos = context.allocateLocal('pos');
    final predicate = this.predicate.build(context, 'predicate', [c]);
    final isUnicode = this.predicate.isUnicode;
    code + 'final $pos = state.pos;';
    code + 'int? $c;';
    final result1 = helper.getResult(context, code, parser, false);
    helper.build(context, code, parser, result1, silent, onSuccess: (code) {
      code += fast ? '$c = ${result1.valueUnsafe};' : '$c = ${result1.value};';
      code.setState(predicate);
      code.ifSuccess((code) {
        code.setResult(result, result1.name, false);
      });
    });
    code.ifFailure((code) {
      code + 'state.pos = $pos;';
      code += silent
          ? ''
          : isUnicode
              ? 'state.error = ErrUnexpected.charOrEof(state.pos, source, $c);'
              : 'state.error = ErrUnexpected.charOrEof(state.pos, source);';
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
