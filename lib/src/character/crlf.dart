part of '../../character.dart';

/// Parses a sequence of characters '\r\n' and returns a string containing
/// those characters.
///
/// Examaple:
/// ```dart
/// Crlf()
/// ```
class Crlf extends ParserBuilder<String, String> {
  static const _template = r'''
state.ok = false;
if (state.ch == 0xD) {
  final pos = state.pos;
  final ch = state.ch;
  if (state.nextChar() == 0xA) {
    state.nextChar();
    state.ok = true;
    {{res}} = '\r\n';
  } else {
    state.error = ErrExpected.char(state.pos, const Char(0xA));
    state.pos = pos;
    state.ch = ch;
  }
} else {
  state.error = ErrExpected.char(state.pos, const Char(0xD));
}''';

  const Crlf();

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
