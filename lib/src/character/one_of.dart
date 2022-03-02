part of '../../character.dart';

/// Parses a single character and returns that character if it is in the
/// specified list of [characters].
///
/// Example:
/// ```dart
/// OneOf([0x22, 0x27])
/// ```
class OneOf extends StringParserBuilder<int> {
  static const _template = '''
state.ok = false;
if (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  c = c <= 0xD7FF || c >= 0xE000 ? c : source.runeAt(state.pos);
  if ({{test}}) {
    state.pos += c > 0xffff ? 2 : 1;
    state.ok = true;
    {{res}} = c;
  } else {
    state.error = ErrUnexpected.char(state.pos, Char(c));
  }
} else {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  final List<int> characters;

  const OneOf(this.characters);

  @override
  Map<String, String> getTags(Context context) {
    if (characters.isEmpty) {
      throw StateError('List of characters must not be empty');
    }

    return {
      'test': characters.map((e) => 'c == ' + helper.toHex(e)).join(' || '),
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([characters]);
  }
}
