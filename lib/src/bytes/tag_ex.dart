part of '../../bytes.dart';

/// Parses the tag whose value is obtained as the result returned by the
/// non-parameterized transformer [tag] and returns the tag.
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
} else if (state.log) {
  state.error = ErrExpected.tag(state.pos, Tag({{tag}}));
}''';

  final Transformer<String> tag;

  const TagEx(this.tag);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['get', 'tag']);
    final get = locals['get']!;
    final t = Transformation(context: context, name: get, arguments: []);
    return {
      ...locals,
      'transform': tag.declare(t),
      'cond': tag.invoke(t),
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
