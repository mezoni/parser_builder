part of '../../character.dart';

/// Parses a single character and returns any character if it is not in the
/// list of characters obtained as the result returned by the transformer
/// [characters].
///
/// Example:
/// ```dart
/// NoneOfEx(ContextGet('delimiters))
/// ```
class NoneOfEx extends StringParserBuilder<int> {
  static const _template = '''
state.ok = true;
if (state.pos < source.length) {
  final pos = state.pos;
  var c = source.readRune(state);
  {{transform}}
  final list = {{chars}};
  for (var i = 0; i < list.length; i++) {
    final ch = list[i];
    if (c == ch) {
      state.pos = pos;
      state.ok = false;
      if (!state.opt) {
        state.error = ErrUnexpected.char(state.pos, Char(c));
      }
      break;
    }
  }
  if (state.ok) {
    {{res}} = c;
  }
} else {
  if (!state.opt) {
    state.error = ErrUnexpected.eof(state.pos);
  }
  state.ok = false;
}''';

  final Transformer<List<int>> characters;

  const NoneOfEx(this.characters);

  @override
  Map<String, String> getTags(Context context) {
    final t = Transformation(context: context, name: 'chars', arguments: []);
    return {
      'transform': characters.declare(t),
      'chars': characters.invoke(t),
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
