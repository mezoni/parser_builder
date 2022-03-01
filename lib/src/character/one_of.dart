part of '../../character.dart';

/// Parses a single character and returns that character if it is in the
/// specified list of [characters].
///
/// Example:
/// ```dart
/// OneOf([0x22, 0x27])
/// ```
class OneOf extends ParserBuilder<String, int> {
  static const _template = '''
if (state.ch != State.eof) {
  final c =  state.ch;
  state.ok = {{test}};
  if (state.ok) {
    {{res}} = state.ch;
    state.nextChar();
  } else {
    state.error = ErrUnexpected.char(state.pos, Char(state.ch));
  }
} else {
  state.ok = false;
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
