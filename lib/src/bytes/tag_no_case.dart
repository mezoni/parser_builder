part of '../../bytes.dart';

/// Parses [tag] case-insensitively with the [convert] function and returns
/// [tag].
///
/// Example:
/// ```dart
/// TagNoCase('if')
/// ```
class TagNoCase extends StringParserBuilder<String> {
  static const _template = '''
state.ok = false;
if (state.pos + {{len}} <= source.length) {
  {{transform}}
  final v1 = source.substring(state.pos, state.pos + {{len}});
  final v2 = {{conv}};
  if (v2 == {{tag}}) {
    state.ok = true;
    state.pos += {{len}};
    {{res}} = v1;
  }
}
if (!state.ok && !state.opt) {
  state.error = ErrExpected.tag(state.pos, const Tag({{tag}}));
}''';

  final Transformer<String, String> convert;

  final String tag;

  const TagNoCase(this.tag, this.convert);

  @override
  Map<String, String> getTags(Context context) {
    if (tag.isEmpty) {
      throw ArgumentError.value(tag, 'tag', 'The tag must not be empty');
    }

    return {
      'len': tag.length.toString(),
      'tag': helper.escapeString(tag),
      ...helper.tfToTemplateValues(convert, key: 'conv', value: 'v1'),
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
