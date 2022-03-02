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
  var c = source.codeUnitAt(state.pos);
  c = c & 0xfc00 != 0xd800 ? c : source.runeAt(state.pos);
  state.pos += c > 0xffff ? 2 : 1;
  {{res}} = c;
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
