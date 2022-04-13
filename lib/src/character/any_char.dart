part of '../../character.dart';

/// Parses any single character and returns that character.
///
/// Example:
/// ```dart
/// AnyChar()
/// ```
class AnyChar extends StringParserBuilder<int> {
  const AnyChar();

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    context.refersToStateSource = true;
    final key = BuidlResult();
    code.setState('state.pos < source.length');
    code.ifSuccess((code) {
      code.setResult(result, 'source.readRune(state)');
      code.labelSuccess(key);
    }, else_: ((code) {
      code += silent ? '' : 'state.error = ErrUnexpected.eof(state.pos);';
    }));
    return key;
  }
}
