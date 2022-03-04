part of '../../bytes.dart';

/// Parses the tag whose value is obtained as the result returned by the
/// transformer [tag] and returns the tag.
///
/// Example:
/// ```dart
/// TagEx(TX('state.context.separator as String'))
/// ```
class TagEx extends StringParserBuilder<String> {
  static const _template = '''
{{transform}}
final {{tag}} = {{get}}(null);
state.ok = source.startsWith({{tag}}, state.pos);
if (state.ok) {
  state.pos += {{tag}}.length;
  {{res}}= {{tag}};
} else if (!state.opt) {
  state.error = ErrExpected.tag(state.pos, Tag({{tag}}));
}''';

  final Transformer<dynamic, String> tag;

  const TagEx(this.tag);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['get', 'tag']);
    return {
      'transform': tag.transform(locals['get']!),
    }..addAll(locals);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
