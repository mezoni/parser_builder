part of '../../character.dart';

/// Parses a single character and returns any character if it is not in the
/// list of characters obtained as the result returned by the transformer
/// [chars].
///
/// Example:
/// ```dart
/// NoneOfOf(ContextGet('delimiters))
/// ```
class NoneOfOf extends StringParserBuilder<int> {
  final ParserBuilder<String, List<int>> chars;

  const NoneOfOf(this.chars);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    context.refersToStateSource = true;
    final key = BuidlResult();
    final c = context.allocateLocal('c');
    final result1 = helper.getResult(context, code, chars, false);
    helper.build(context, code, chars, result1, silent, onSuccess: (code) {
      code.setState('state.pos < source.length');
      code.ifSuccess((code) {
        code + 'final pos = state.pos;';
        code + 'final $c = source.readRune(state);';
        code + 'final list = ${result1.value};';
        code.iteration('for (var i = 0; i < list.length; i++)', (code) {
          code + 'final ch = list[i];';
          code.if_('$c == ch', (code) {
            code + 'state.pos = pos;';
            code.setFailure();
            code += silent
                ? ''
                : 'state.error = ErrUnexpected.char(state.pos, Char($c));';
            code.break$();
          });
        });
        code.ifSuccess((code) {
          code.setResult(result, c);
          code.labelSuccess(key);
        });
      }, else_: (code) {
        code += silent ? '' : 'state.error = ErrUnexpected.eof(state.pos);';
      });
    });
    return key;
  }
}