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
state.ok = false;
if (state.ch != State.eof) {
  const list = [{{values}}];
  for (var i = 0; i < {{len}}; i++) {
    final c = list[i];
    if (state.ch == c) {
      state.ok = true;
      {{res}} = c;
      state.nextChar();
      break;
    }
  }
  if (!state.ok) {
    state.error = ErrUnexpected.char(state.pos, Char(state.ch));
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
      'len': characters.length.toString(),
      'values': characters.map(helper.toHex).join(', '),
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
