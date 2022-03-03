part of '../../character.dart';

/// Parses one character with code [value] and returns that character.
///
/// Example:
/// ```dart
/// Char(0x30)
/// ```
class Char extends StringParserBuilder<int> {
  static const _template16 = '''
state.ok = false;
if (state.pos < source.length) {
  final c = source.codeUnitAt(state.pos);
  if (c == {{cc}}) {
    state.pos++;
    state.ok = true;
    {{res}} = {{cc}};
  }
}
if (!state.ok && !state.opt) {
  state.error = ErrExpected.char(state.pos, const Char({{cc}}));
}''';

  static const _template32 = '''
state.ok = false;
if (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  c = c & 0xfc00 != 0xd800 ? c : source.runeAt(state.pos);
  if (c == {{cc}}) {
    state.pos += 2;
    state.ok = true;
    {{res}} = {{cc}};
  }
}
if (!state.ok && !state.opt) {
  state.error = ErrExpected.char(state.pos, const Char({{cc}}));
}''';

  final int value;

  const Char(this.value);

  @override
  Map<String, String> getTags(Context context) {
    return {'cc': helper.toHex(value)};
  }

  @override
  String getTemplate(Context context) {
    final has32BitChars = value > 0xffff;
    return has32BitChars ? _template32 : _template16;
  }

  @override
  String toString() {
    return printName([value]);
  }
}
