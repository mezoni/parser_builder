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
final {{c}} = state.ch;
if ({{c}} != State.eof) {
  {{transform}}
  final list = get(null);
  for (var i = 0; i < list.length; i++) {
    final c = list[i];
    if ({{c}} == c) {
      state.ok = false;
      state.error = ErrUnexpected.char(state.pos, Char({{c}}));
      break;
    }
  }
  if (state.ok) {
    {{res}} = {{c}};
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
    final locals = context.allocateLocals(['c']);
    return {
      'transform': characters.transform('get'),
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
