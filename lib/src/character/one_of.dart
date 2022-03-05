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
if (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  if ({{cond}}) {
    state.pos++;
    state.ok = true;
    {{res}} = c;
  } else if (!state.opt) {
    c = c & 0xfc00 != 0xd800 ? c : source.runeAt(state.pos);
    state.error = ErrUnexpected.char(state.pos, Char(c));
  }
} else if (!state.opt) {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  static const _template32 = '''
state.ok = false;
if (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  c = c & 0xfc00 != 0xd800 ? c : source.runeAt(state.pos);
  if ({{cond}}) {
    state.pos += c > 0xffff ? 2 : 1;
    state.ok = true;
    {{res}} = c;
  } else if (!state.opt) {
    state.error = ErrUnexpected.char(state.pos, Char(c));
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

    final cond = ExprTransformer(
        'c', characters.map((e) => '{{c}} == ' + helper.toHex(e)).join(' || '));
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
