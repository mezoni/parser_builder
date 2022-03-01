part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria, and returns true if the
/// criteria was satisfied at least once.
///
/// Example:
/// ```dart
/// SkipWhile1(CharClass('[#x30-#x39]'), unicode: false)
/// ```
class SkipWhile1 extends ParserBuilder<String, bool> {
  static const _template = '''
var {{c}} = state.ch;
{{transform}}
while ({{c}} != State.eof && {{test}}({{c}})) {
  {{c}} = state.nextChar();
  {{res}} = true;
}
state.ok = {{res}} != null;
if (!state.ok) {
  state.error = {{c}} == State.eof ? ErrUnexpected.eof(state.pos) : ErrUnexpected.char(state.pos, Char({{c}}));
}''';

  final Transformer<int, bool> predicate;

  final bool unicode;

  const SkipWhile1(this.predicate, {this.unicode = true});

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['c', 'test']);
    return {
      'transform': predicate.transform(locals['test']!),
    }..addAll(locals);
  }
}
