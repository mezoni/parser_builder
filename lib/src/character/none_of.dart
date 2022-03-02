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
  c = c & 0xfc00 != 0xd800 ? c : source.runeAt(state.pos);
  if ({{test}}) {
    state.pos += c > 0xffff ? 2 : 1;
    state.ok = true;
    {{res}} = c;
  } else {
    state.error = ErrUnexpected.char(state.pos, Char(c));
  }
} else {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  static const _template32 = '''
state.ok = false;
if (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  c = c & 0xfc00 != 0xd800 ? c : source.runeAt(state.pos);
  if ({{test}}) {
    state.pos += c > 0xffff ? 2 : 1;
    state.ok = true;
    {{res}} = c;
  } else {
    state.error = ErrUnexpected.char(state.pos, Char(c));
  }
} else {
  state.error = ErrUnexpected.eof(state.pos);
}''';

  final List<int> characters;

  const NoneOf(this.characters);

  @override
  Map<String, String> getTags(Context context) {
    if (characters.isEmpty) {
      throw StateError('List of characters must not be empty');
    }

    return {
      'test': characters.map((e) => 'c != ' + helper.toHex(e)).join(' && '),
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
