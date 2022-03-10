part of '../../character.dart';

/// Parses one character with code [value] and returns that character.
///
/// Example:
/// ```dart
/// Char(0x30)
/// ```
class Char extends StringParserBuilder<int> {
  static const _template16 = '''
state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == {{cc}};
if (state.ok) {
  state.pos++;
  {{res}} = {{cc}};
} else if (state.log) {
  state.error = ErrExpected.char(state.pos, const Char({{cc}}));
}''';

  static const _template32 = '''
state.ok = state.pos < source.length && source.runeAt(state.pos) == {{cc}};
if (state.ok) {
  state.pos += 2;
  {{res}} = {{cc}};
} else if (state.log) {
  state.error = ErrExpected.char(state.pos, const Char({{cc}}));
}''';

  final int value;

  const Char(this.value);

  @override
  Map<String, String> getTags(Context context) {
    return {
      'cc': value.toString(),
    };
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
