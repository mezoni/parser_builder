part of '../../character.dart';

/// Parses one character with code [value] and returns that character.
///
/// Example:
/// ```dart
/// Char(0x30)
/// ```
class Char extends ParserBuilder<String, int> {
  static const _template = '''
state.ok = state.ch == {{cc}};
if (state.ok) {
  {{res}} = {{cc}};
  state.nextChar();
} else {
  state.error = ErrExpected.char(state.pos, const Char({{cc}}));
}''';

  final int value;

  const Char(this.value);

  @override
  Map<String, String> getTags(Context context) {
    return {
      'cc': helper.toHex(value),
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([value]);
  }
}
