part of '../../character.dart';

/// Parses any single character and returns that character.
///
/// Example:
/// ```dart
/// AnyChar()
/// ```
class AnyChar extends StringParserBuilder<int> {
  static const _template = '''
state.ok = state.pos < source.length;
if (state.ok) {
  {{res}} = source.readRune(state);
} else if (state.log) {
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
