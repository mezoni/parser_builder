part of '../../character.dart';

/// Parses a single character and returns any character if it is not in the
/// list of characters obtained as the result returned by the transformer
/// [characters].
///
/// Example:
/// ```dart
/// NoneOfEx(ContextGet('delimiters))
/// ```
class NoneOfEx extends ParserBuilder<String, int> {
  static const _template = '''
state.ok = true;
if (state.ch != State.eof) {
  {{transform}}
  final list = get(null);
  for (var i = 0; i < list.length; i++) {
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

  final Transformer<dynamic, List<int>> characters;

  const NoneOfEx(this.characters);

  @override
  Map<String, String> getTags(Context context) {
    return {
      'transform': characters.transform('get'),
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
