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
  void build(Context context, CodeGen code) {
    context.refersToStateSource = true;
    code.isNotEof();
    code.ifSuccess((code) {
      if (code.fast) {
        code.add('source.readRune(state);');
      } else {
        code.setResult('source.readRune(state)');
      }
    }, else_: ((code) {
      code.errorUnexpectedEof();
    }));
  }
}
