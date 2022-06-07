part of '../../character.dart';

/// Parses one character with code [char] and returns that character.
///
/// Example:
/// ```dart
/// Char(0x30)
/// ```
class Char extends ParserBuilder<String, int> {
  static const _template16 = '''
if (source.contains1(state.pos, {{c0}})) {
  state.ok = true;
  state.pos++;
  {{res0}} = {{cc}};
} else {
  state.fail(state.pos, ParseError.expected, {{cc}});
}''';

  static const _template16Fast = '''
if (source.contains1(state.pos, {{c0}})) {
  state.ok = true;
  state.pos++;
} else {
  state.fail(state.pos, ParseError.expected, {{cc}});
}''';

  static const _template32 = '''
if (source.contains2(state.pos, {{c0}}, {{c1}})) {
  state.ok = true;
  state.pos += 2;
  {{res0}} = {{cc}};
} else {
  state.fail(state.pos, ParseError.expected, {{cc}});
}''';

  static const _template32Fast = '''
if (source.contains2(state.pos, {{c0}}, {{c1}})) {
  state.ok = true;
  state.pos += 2;
} else {
  state.fail(state.pos, ParseError.expected, {{cc}});
}''';

  final int char;

  const Char(this.char);

  @override
  String build(Context context, ParserResult? result) {
    if (!(char >= 0 && char <= 0xd7ff || char >= 0xe000 && char <= 0x10ffff)) {
      throw ArgumentError.value(char, 'char', 'Invalid character code');
    }

    context.refersToStateSource = true;
    final fast = result == null;
    final str = String.fromCharCode(char);
    final isUnicode = str.length > 1;
    final String template;
    if (isUnicode) {
      template = fast ? _template32Fast : _template32;
    } else {
      template = fast ? _template16Fast : _template16;
    }

    final values = {
      'c0': '${str.codeUnitAt(0)}',
      'c1': isUnicode ? '${str.codeUnitAt(1)}' : '',
      'cc': '$char',
    };
    return render(template, values, [result]);
  }
}
