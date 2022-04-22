part of '../../character.dart';

/// Parses one character with code [char] and returns that character.
///
/// Example:
/// ```dart
/// Char(0x30)
/// ```
class Char extends ParserBuilder<String, int> {
  static const _template16 = '''
state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == {{cc}};
if (state.ok) {
  state.pos++;
  {{res0}} = {{cc}};
} else if (state.log) {
  state.error = ErrExpected.char(state.pos, const Char({{cc}}));
}''';

  static const _template16Fast = '''
state.ok = state.pos < source.length && source.codeUnitAt(state.pos) == {{cc}};
if (state.ok) {
  state.pos++;
} else if (state.log) {
  state.error = ErrExpected.char(state.pos, const Char({{cc}}));
}''';

  static const _template32 = '''
state.ok = state.pos < source.length && source.runeAt(state.pos) == {{cc}};
if (state.ok) {
  state.pos += 2;
  {{res0}} = {{cc}};
} else if (state.log) {
  state.error = ErrExpected.char(state.pos, const Char({{cc}}));
}''';

  static const _template32Fast = '''
state.ok = state.pos < source.length && source.runeAt(state.pos) == {{cc}};
if (state.ok) {
  state.pos += 2;
} else if (state.log) {
  state.error = ErrExpected.char(state.pos, const Char({{cc}}));
}''';

  final int char;

  const Char(this.char);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    final fast = result == null;
    final values = {
      'cc': helper.getAsCode(char),
    };
    final isUnicode = char > 0xffff;
    final String template;
    if (isUnicode) {
      if (fast) {
        template = _template32Fast;
      } else {
        template = _template32;
      }
    } else {
      if (fast) {
        template = _template16Fast;
      } else {
        template = _template16;
      }
    }

    return render(template, values, [result]);
  }
}
