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
  var size = 1;
  var c = source.codeUnitAt(state.pos);
  if (c > 0xd7ff) {
    c = source.runeAt(state.pos);
    size = c > 0xffff ? 2 : 1;
  }
  state.pos += size;
  {{res}} = c;
} else if (!state.opt) {
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
