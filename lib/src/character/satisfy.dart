part of '../../character.dart';

/// Parses a single character, and if [characters] satisfies the criteria,
/// returns that character.
///
/// Example:
/// ```dart
/// Satisfy(isSomeChar)
/// ```
class Satisfy extends StringParserBuilder<int> {
  static const _template16 = '''
state.ok = false;
if (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  {{transform}}
  state.ok = {{cond}};
  if (state.ok) {
    state.pos++;
    {{res}} = c;
  } else if (!state.opt) {
    if (c > 0xd7ff) {
      c = source.runeAt(state.pos);
    }
    state.error = ErrUnexpected.char(state.pos, Char(c));
  }
} else if (!state.opt) {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  static const _template32 = '''
state.ok = false;
if (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  if (c > 0xd7ff) {
    c = source.runeAt(state.pos);
  }
  {{transform}}
  state.ok = {{cond}};
  if (state.ok) {
    state.pos += c > 0xffff ? 2 : 1;
    {{res}} = c;
  } else if (!state.opt) {
    state.error = ErrUnexpected.char(state.pos, Char(c));
  }
} else if (!state.opt) {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  final Transformer<int, bool> predicate;

  const Satisfy(this.predicate);

  @override
  Map<String, String> getTags(Context context) {
    return {
      ...helper.tfToTemplateValues(predicate, key: 'cond', value: 'c'),
    };
  }

  @override
  String getTemplate(Context context) {
    final has32BitChars = predicate is CharPredicate
        ? (predicate as CharPredicate).has32BitChars
        : true;
    return has32BitChars ? _template32 : _template16;
  }

  @override
  String toString() {
    return printName([predicate]);
  }
}
