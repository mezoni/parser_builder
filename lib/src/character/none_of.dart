part of '../../character.dart';

/// Parses a single character and returns any character if it is not in the
/// specified list of [characters].
///
/// Example:
/// ```dart
/// NoneOf([0x22, 0x27])
/// ```
class NoneOf extends ParserBuilder<String, int> {
  static const _template = '''
state.ok = true;
if (state.ch != State.eof) {
  const list = [{{values}}];
  for (var i = 0; i < {{len}}; i++) {
    final c = list[i];
    if (state.ch == c) {
      state.ok = false;
      state.error = ErrUnexpected.char(state.pos, Char(state.ch));
      break;
    }
  }
  if (state.ok) {
    {{res}} = state.ch;
    state.nextChar();
  }
} else {
  state.ok = false;
  state.error = ErrUnexpected.eof(state.pos);
}''';

  final List<int> characters;

  const NoneOf(this.characters);

  @override
  Map<String, String> getTags(Context context) {
    if (characters.isEmpty) {
      throw StateError('List of characters must not be empty');
    }

    final locals = context.allocateLocals(['pos']);
    return {
      'len': characters.length.toString(),
      'values': characters.map(helper.toHex).join(', '),
    }..addAll(locals);
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
