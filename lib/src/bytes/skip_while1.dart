part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria, and returns true if the
/// criteria was satisfied at least once.
///
/// Example:
/// ```dart
/// SkipWhile1(CharClass('[#x30-#x39]'), unicode: false)
/// ```
class SkipWhile1 extends StringParserBuilder<bool> {
  static const _template = '''
var {{c}} = 0;
{{transform}}
while (state.pos < source.length) {
  {{c}} = source.codeUnitAt(state.pos);
  {{c}} = {{c}} <= 0xD7FF || {{c}} >= 0xE000 ? {{c}} : source.runeAt(state.pos);
  if (!{{test}}({{c}})) {
    break;
  }
  state.pos += {{c}} > 0xffff ? 2 : 1;
  {{res}} = true;
}
state.ok = {{res}} != null;
if (!state.ok) {
  state.error = state.pos < source.length ? ErrUnexpected.char(state.pos, Char({{c}})) : ErrUnexpected.eof(state.pos);
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
