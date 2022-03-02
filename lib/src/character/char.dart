part of '../../character.dart';

/// Parses one character with code [value] and returns that character.
///
/// Example:
/// ```dart
/// Char(0x30)
/// ```
class Char extends StringParserBuilder<int> {
  static const _template = '''
state.ok = false;
if (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  c = c <= 0xD7FF || c >= 0xE000 ? c : source.runeAt(state.pos);
  if (c == {{cc}}) {
    state.pos += c > 0xffff ? 2 : 1;
    state.ok = true;
    {{res}} = {{cc}};
  }
}
if (!state.ok) {
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
