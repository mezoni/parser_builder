part of '../../bytes.dart';

/// Parses [tag] case-insensitively with the [convert] function and returns
/// [tag].
///
/// Example:
/// ```dart
/// TagNoCase('if')
/// ```
class TagNoCase extends ParserBuilder<String, String> {
  static const _template = '''
final {{start}} = state.pos;
final {{end}} = {{start}} + {{length}};
state.ok = {{end}} <= source.length;
if (state.ok) {
  final v = source.substring({{start}}, {{end}});
  state.ok = v.toLowerCase() == {{tag}};
  if (state.ok) {
    state.pos = {{end}};
    {{res0}} = v;
  }
}
if (!state.ok && state.log) {
  state.error = ErrExpected.tag({{start}}, const Tag({{tag}}));
}''';

  static const _templateFast = '''
final {{start}} = state.pos;
final {{end}} = {{start}} + {{length}};
state.ok = {{end}} <= source.length;
if (state.ok) {
  final v = source.substring({{start}}, {{end}});
  state.ok = v.toLowerCase() == {{tag}};
  if (state.ok) {
    state.pos = {{end}};
  }
}
if (!state.ok && state.log) {
  state.error = ErrExpected.tag({{start}}, const Tag({{tag}}));
}''';

  final String tag;

  const TagNoCase(this.tag);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    final fast = result == null;
    final values = context.allocateLocals(['end', 'start']);
    values.addAll({
      'length': '${tag.length}',
      'lowerCase': helper.escapeString(tag.toLowerCase()),
      'tag': helper.escapeString(tag),
    });
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
