part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria, and returns true.
///
/// Example:
/// ```dart
/// SkipWhile(CharClass('#x9 | #xA | #xD | #x20'), unicode: false)
/// ```
class SkipWhile extends StringParserBuilder<bool> {
  static const _template = '''
state.ok = true;
{{transform}}
while (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  c = c <= 0xD7FF || c >= 0xE000 ? c : source.runeAt(state.pos);
  if (!{{test}}(c)) {
    break;
  }
  state.pos += c > 0xffff ? 2 : 1;
}
if (state.ok) {
  {{res}} = true;
}''';

  final Transformer<int, bool> predicate;

  const SkipWhile(this.predicate);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['test']);
    return {
      'transform': predicate.transform(locals['test']!),
    }..addAll(locals);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
