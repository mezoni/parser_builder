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
  var c = source.codeUnitAt(state.pos);
  c = c & 0xfc00 != 0xd800 ? c : source.runeAt(state.pos);
  {{transform}}
  final list = get(null);
  for (var i = 0; i < list.length; i++) {
    final ch = list[i];
    if (c == ch) {
      state.ok = false;
      if (!state.opt) {
        state.error = ErrUnexpected.char(state.pos, Char(c));
      }
      break;
    }
  }
  if (state.ok) {
    state.pos += c > 0xffff ? 2 : 1;
    {{res}} = c;
  }
} else {
  if (!state.opt) {
    state.error = ErrUnexpected.eof(state.pos);
  }
  state.ok = false;
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
