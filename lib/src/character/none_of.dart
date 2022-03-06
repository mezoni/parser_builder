part of '../../character.dart';

/// Parses a single character and returns any character if it is not in the
/// specified list of [characters].
///
/// Example:
/// ```dart
/// NoneOf([0x22, 0x27])
/// ```
class NoneOf extends StringParserBuilder<int> {
  static const _template16 = '''
state.ok = false;
if (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  if (c > 0xd7ff) {
    c = source.runeAt(state.pos);
  }
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

  static const _template32 = '''
state.ok = false;
if (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  if (c > 0xd7ff) {
    c = source.runeAt(state.pos);
  }
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

  final List<int> characters;

  const NoneOf(this.characters);

  @override
  Map<String, String> getTags(Context context) {
    if (characters.isEmpty) {
      throw StateError('List of characters must not be empty');
    }

    final cond = ExprTransformer(
        'c', characters.map((e) => 'c != ' + e.toString()).join(' && '));
    return {
      'cond': cond.inline('c'),
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
