part of '../../character.dart';

/// Parses a single character and returns that character if it is in the
/// specified list of [characters].
///
/// Example:
/// ```dart
/// OneOf([0x22, 0x27])
/// ```
class OneOf extends StringParserBuilder<int> {
  static const _template16 = '''
state.ok = false;
{{transform}}
if (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  state.ok = {{cond}};
  if (state.ok) {
    state.pos++;
    {{res}} = c;
  } else if (!state.opt) {
    state.error = ErrUnexpected.char(state.pos, Char(source.runeAt(state.pos)));
  }
} else if (!state.opt) {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  static const _template32 = '''
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
    if (!state.opt) {
      state.error = ErrUnexpected.char(state.pos, Char(c));
    }
  }
} else if (!state.opt) {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  final List<int> characters;

  const OneOf(this.characters);

  @override
  Map<String, String> getTags(Context context) {
    if (characters.isEmpty) {
      throw StateError('List of characters must not be empty');
    }

    final predicate = ExprTransformer(
        ['c'], characters.map((e) => '{{c}} == ' + e.toString()).join(' || '));
    final t = Transformation(context: context, name: 'cond', arguments: ['c']);
    return {
      'transform': predicate.declare(t),
      'cond': predicate.invoke(t),
    };
  }

  @override
  String getTemplate(Context context) {
    final has32BitChars = characters.any((e) => e > 0xffff);
    return has32BitChars ? _template32 : _template16;
  }

  @override
  String toString() {
    return printName([characters]);
  }
}
