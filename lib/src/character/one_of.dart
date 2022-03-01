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
final {{c}} = state.ch;
if ({{c}} != State.eof) {
  state.ok = {{test}};
  if (state.ok) {
    {{res}} = {{c}};
    state.nextChar();
  } else {
    state.error = ErrUnexpected.char(state.pos, Char({{c}}));
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

    final locals = context.allocateLocals(['c']);
    final c = locals['c'];
    return {
      'test': characters.map((e) => '$c == ' + helper.toHex(e)).join(' || '),
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
