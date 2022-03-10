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
  {{transform}}
  final c = source.codeUnitAt(state.pos);
  state.ok = {{cond}};
  if (state.ok) {
    state.pos++;
    {{res}} = c;
  } else if (state.log) {
    state.error = ErrUnexpected.char(state.pos, Char(source.runeAt(state.pos)));
  }
} else if (state.log) {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  static const _template32 = '''
state.ok = false;
if (state.pos < source.length) {
  {{transform}}
  final pos = state.pos;
  final c = source.readRune(state);
  state.ok = {{cond}};
  if (state.ok) {
    {{res}} = c;
  } else {
    state.pos = pos;
    if (state.log) {
      state.error = ErrUnexpected.char(state.pos, Char(c));
    }
  }
} else if (state.log) {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  final Transformer<bool> predicate;

  const Satisfy(this.predicate);

  @override
  Map<String, String> getTags(Context context) {
    final t = Transformation(context: context, name: 'cond', arguments: ['c']);
    return {
      'transform': predicate.declare(t),
      'cond': predicate.invoke(t),
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
