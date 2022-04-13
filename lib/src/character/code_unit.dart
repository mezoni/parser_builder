part of '../../character.dart';

class CodeUnit extends StringParserBuilder<int> {
  const CodeUnit();

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    context.refersToStateSource = true;
    final key = BuidlResult();
    code.setState('state.pos < source.length');
    code.ifSuccess((code) {
      code.setResult(result, 'source.codeUnitAt(state.pos++)');
      code.labelSuccess(key);
    }, else_: ((code) {
      code += silent ? '' : 'state.error = ErrUnexpected.eof(state.pos);';
    }));
    return key;
  }
}
