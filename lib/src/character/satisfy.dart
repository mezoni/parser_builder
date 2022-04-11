part of '../../character.dart';

/// Parses a single character, and if [characters] satisfies the criteria,
/// returns that character.
///
/// Example:
/// ```dart
/// Satisfy(isSomeChar)
/// ```
class Satisfy extends StringParserBuilder<int> {
  final SemanticAction<bool> predicate;

  const Satisfy(this.predicate);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    context.refersToStateSource = true;
    final isUnicode = predicate.isUnicode;
    if (isUnicode) {
      _build32(context, code, result, silent);
    } else {
      _build16(context, code, result, silent);
    }
  }

  void _build16(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final c = context.allocateLocal('c');
    final predicate = this.predicate.build(context, 'predicate', [c]);
    code + 'int? $c;';
    code.setState('state.pos < source.length');
    code.ifSuccess((code) {
      code + '$c = source.codeUnitAt(state.pos);';
      code.setState(predicate);
    });
    code.ifSuccess((code) {
      code + 'state.pos++;';
      code.setResult(result, c);
      code.labelSuccess(result);
    }, else_: (code) {
      code += silent
          ? ''
          : 'state.error =  $c == null ? ErrUnexpected.eof(state.pos) : ErrUnexpected.charAt(state.pos, source);';
      code.labelFailure(result);
    });
  }

  void _build32(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final c = context.allocateLocal('c');
    final pos = context.allocateLocal('pos');
    final predicate = this.predicate.build(context, 'predicate', [c]);
    code + 'final $pos = state.pos;';
    code + 'int? $c;';
    code.setState('state.pos < source.length');
    code.ifSuccess((code) {
      code + '$c = source.readRune(state);';
      code.setState(predicate);
    });
    code.ifSuccess((code) {
      code.setResult(result, c);
      code.labelSuccess(result);
    }, else_: (code) {
      code + 'state.pos = $pos;';
      code += silent
          ? ''
          : 'state.error =  $c == null ? ErrUnexpected.eof(state.pos) : ErrUnexpected.char(state.pos, Char($c));';
      code.labelFailure(result);
    });
  }
}
