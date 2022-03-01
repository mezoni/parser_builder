part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and returns a substring of
/// the parsed data.
///
/// Example:
/// ```dart
/// TakeWhile(CharClass('[#x21-#x7e]'))
/// ```
class TakeWhile extends ParserBuilder<String, String> {
  static const _template = '''
final {{pos}} = state.pos;
var {{c}} = state.ch;
{{transform}}
while ({{c}} != State.eof && {{test}}({{c}})) {
  {{c}} = state.nextChar();
}
state.ok = true;
if (state.ok) {
  {{res}} = state.source.substring({{pos}}, state.pos);
}''';

  final Transformer<int, bool> predicate;

  const TakeWhile(this.predicate);

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
