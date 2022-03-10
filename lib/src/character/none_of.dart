part of '../../character.dart';

/// Parses a single character and returns any character if it is not in the
/// specified list of [characters].
///
/// Example:
/// ```dart
/// NoneOf([0x22, 0x27])
/// ```
class NoneOf extends StringParserBuilder<int> {
  static const _template = '''
state.ok = false;
{{transform}}
if (state.pos < source.length) {
  final pos = state.pos;
  var c = source.readRune(state);
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

  final List<int> characters;

  const NoneOf(this.characters);

  @override
  Map<String, String> getTags(Context context) {
    if (characters.isEmpty) {
      throw StateError('List of characters must not be empty');
    }

    final predicate = ExprTransformer(
        ['c'], characters.map((e) => '{{c}} != ' + e.toString()).join(' && '));
    final t = Transformation(context: context, name: 'cond', arguments: ['c']);
    return {
      'transform': predicate.declare(t),
      'cond': predicate.invoke(t),
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
