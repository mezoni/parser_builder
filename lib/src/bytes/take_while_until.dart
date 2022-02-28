part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and until encounters the
/// [tag], sets the position to the position of the found tag and returns a
/// substring of the parsed data excluding the tag.
///
/// Examples:
///
/// ```dart
/// TakeWhileUntil(_CData, ']]>')
/// ```
class TakeWhileUntil extends StringParserBuilder<String> {
  static const _template = '''
final {{index}} = source.indexOf({{tag}}, state.pos);
if ({{index}} != -1) {
  final pos = state.pos;
  final ch = state.ch;
  {{transform}}
  while (state.pos < {{index}}) {
    if (state.ch == State.eof || !test(state.ch)) {
      break;
    }
    state.nextChar();
  }
  state.ok = state.pos == {{index}};
  if (state.ok) {
    {{res}} = source.substring(pos, state.pos);
  } else {
    state.error = ErrUnexpected.char(state.pos, Char(state.ch));
    state.pos = pos;
    state.ch = ch;
  }
} else {
  state.ok = false;
  state.error = ErrExpected.tag(state.pos, const Tag({{tag}}));
}''';

  final Transformer<int, bool> predicate;

  final String tag;

  const TakeWhileUntil(this.predicate, this.tag);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['index']);
    return {
      'tag': helper.escapeString(tag),
      'transform': predicate.transform('test'),
    }..addAll(locals);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
