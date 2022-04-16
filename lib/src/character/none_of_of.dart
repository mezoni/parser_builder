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
  void build(Context context, CodeGen code) {
    context.refersToStateSource = true;
    final result = helper.build(context, code, chars, fast: false);
    code.ifSuccess((code) {
      code.setState('state.pos < source.length');
      code.ifSuccess((code) {
        final pos = code.savePos();
        final c = code.val('c', 'source.readRune(state)');
        final list = code.val('list', result.value);
        code.iteration('for (var i = 0; i < $list.length; i++)', (code) {
          final ch = code.val('ch', '$list[i]');
          code.if_('$c == $ch', (code) {
            code.setPos(pos);
            code.setFailure();
            code.setError('ErrUnexpected.char(state.pos, Char($c))');
            code.break$();
          });
        });
        code.ifSuccess((code) {
          code.setResult(c);
        });
      }, else_: (code) {
        code.errorUnexpectedEof();
      });
    });
  }
}
