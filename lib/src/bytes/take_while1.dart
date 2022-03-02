part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and returns a substring of
/// the parsed data if the criteria was satisfied at least once.
///
/// Example:
/// ```dart
/// TakeWhile1(CharClass('[A-Z] | [a-z] |  "_"'))
/// ```
class TakeWhile1 extends StringParserBuilder<String> {
  static const _template = '''
final {{pos}} = state.pos;
var {{c}} = 0;
{{transform}}
while (state.pos < source.length) {
  {{c}} = source.codeUnitAt(state.pos);
  {{c}} = {{c}} <= 0xD7FF || {{c}} >= 0xE000 ? {{c}} : source.runeAt(state.pos);
  if (!{{test}}({{c}})) {
    break;
  }
  state.pos += {{c}} > 0xffff ? 2 : 1;
  state.ok = true;
}
if (state.ok) {
  {{res}} = source.substring({{pos}}, state.pos);
} else  {
  state.error = state.pos < source.length ? ErrUnexpected.char(state.pos, Char({{c}})) : ErrUnexpected.eof(state.pos);
}''';

  final Transformer<int, bool> predicate;

  const TakeWhile1(this.predicate);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['pos', 'c', 'test']);
    return {
      'transform': predicate.transform(locals['test']!),
    }..addAll(locals);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
