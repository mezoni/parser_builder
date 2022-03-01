part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria, and returns true.
///
/// Example:
/// ```dart
/// SkipWhile(CharClass('#x9 | #xA | #xD | #x20'), unicode: false)
/// ```
class SkipWhile extends ParserBuilder<String, bool> {
  static const _template = '''
var {{c}} = state.ch;
{{transform}}
while ({{c}} != State.eof && {{test}}({{c}})) {
  {{c}} = state.nextChar();
}
state.ok = true;
if (state.ok) {
  {{res}} = true;
}''';

  final Transformer<int, bool> predicate;

  const SkipWhile(this.predicate);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['c', 'test']);
    return {
      'transform': predicate.transform(locals['test']!),
    }..addAll(locals);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
