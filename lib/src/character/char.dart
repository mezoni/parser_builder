part of '../../character.dart';

/// Parses one character with code [value] and returns that character.
///
/// Example:
/// ```dart
/// Char(0x30)
/// ```
class Char extends StringParserBuilder<int> {
  final int value;

  const Char(this.value);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    context.refersToStateSource = true;
    final cc = value.toString();
    final isUnicode = value > 0xffff;
    final length = isUnicode ? 2 : 1;
    final test = isUnicode
        ? 'state.pos < source.length && source.runeAt(state.pos) == $cc'
        : 'state.pos < source.length && source.codeUnitAt(state.pos) == $cc';
    code.setState(test);
    code.ifSuccess((code) {
      code + 'state.pos += $length;';
      code.setResult(result, cc);
      code.labelSuccess(result);
    }, else_: ((code) {
      code += silent
          ? ''
          : 'state.error = ErrExpected.char(state.pos, const Char($cc));';
      code.labelFailure(result);
    }));
  }
}
