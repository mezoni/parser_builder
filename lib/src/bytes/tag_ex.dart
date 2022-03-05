part of '../../bytes.dart';

/// Parses the tag whose value is obtained as the result returned by the
/// transformer [getTag] and returns the tag.
///
/// Example:
/// ```dart
/// TagEx(TX('state.context.separator as String'))
/// ```
class TagEx extends StringParserBuilder<String> {
  static const _template = '''
{{transform}}
final {{tag}} = {{get}};
state.ok = source.startsWith({{tag}}, state.pos);
if (state.ok) {
  state.pos += {{tag}}.length;
  {{res}}= {{tag}};
} else if (!state.opt) {
  state.error = ErrExpected.tag(state.pos, Tag({{tag}}));
}''';

  final Transformer<dynamic, String> getTag;

  const TagEx(this.getTag);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['get', 'tag']);
    final get = locals['get']!;
    return {
      ...locals,
      ...helper.tfToTemplateValues(getTag,
          key: 'get', name: get, value: 'null'),
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
