part of '../../character.dart';

/// Parses any single character and returns that character.
///
/// Example:
/// ```dart
/// AnyChar()
/// ```
class AnyChar extends ParserBuilder<String, int> {
  static const _template = '''
state.ok = state.ch != State.eof;
if (state.ok) {
  {{res}} = state.ch;
  state.nextChar();
} else {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  const AnyChar();

  @override
  Map<String, String> getTags(Context context) {
    return context.allocateLocals(['pos']);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName(const []);
  }
}
