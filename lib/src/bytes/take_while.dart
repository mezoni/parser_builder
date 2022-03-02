part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and returns a substring of
/// the parsed data.
///
/// Example:
/// ```dart
/// TakeWhile(CharClass('[#x21-#x7e]'))
/// ```
class TakeWhile extends StringParserBuilder<String> {
  static const _template = '''
final {{pos}} = state.pos;
{{transform}}
while (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  c = c <= 0xD7FF || c >= 0xE000 ? c : source.runeAt(state.pos);
  if (!{{test}}(c)) {
    break;
  }
  state.pos += c > 0xffff ? 2 : 1;
}
state.ok = true;
if (state.ok) {
  {{res}} = source.substring({{pos}}, state.pos);
}''';

  final Transformer<int, bool> predicate;

  const TakeWhile(this.predicate);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['pos', 'test']);
    return {
      'transform': predicate.transform(locals['test']!),
    }..addAll(locals);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
