part of '../../character.dart';

/// Parses the end of a string ('\n' or '\r\n') and returns a string containing
/// those characters.
///
/// Examaple:
/// ```dart
/// LineEnding()
/// ```
class LineEnding extends ParserBuilder<String, String> {
  static const _template = r'''
state.ok = false;
switch (state.ch) {
  case 0xA:
    state.nextChar();
    state.ok = true;
    {{res}} = '\n';
    break;
  case 0xD:
    final pos = state.pos;
    final ch = state.ch;
    switch (state.nextChar()) {
      case 0xA:
        state.nextChar();
        state.ok = true;
        {{res}} = '\r\n';
        break;
      default:
        state.error = ErrExpected.char(state.pos, const Char(0xA));
        state.pos = pos;
        state.ch = ch;
    }
    break;
  case State.eof:
    state.error = ErrUnexpected.eof(state.pos);
    break;
  default:
    state.error = ErrUnexpected.char(state.pos, Char(state.ch));
}''';

  const LineEnding();

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
