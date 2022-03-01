part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and returns a substring of
/// the parsed data if the criteria was satisfied at least once.
///
/// Example:
/// ```dart
/// TakeWhile1(CharClass('[A-Z] | [a-z] |  "_"'))
/// ```
class TakeWhile1 extends ParserBuilder<String, String> {
  static const _template = '''
state.ok = false;
final {{pos}} = state.pos;
var {{c}} = state.ch;
{{transform}}
while ({{c}} != State.eof && {{test}}({{c}})) {
  {{c}} = state.nextChar();
  state.ok = true;
}
if (state.ok) {
  {{res}} = state.source.substring({{pos}}, state.pos);
} else  {
  state.error = {{c}} == State.eof ? ErrUnexpected.eof(state.pos) : ErrUnexpected.char(state.pos, Char({{c}}));
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
