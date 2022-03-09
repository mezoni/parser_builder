part of '../../bytes.dart';

/// Parses until the first occurrence of a [tag] is found and returns a
/// substring up to the found [tag].
///
/// Example
/// ```dart
/// TakeUntil('{{')
/// ```
class TakeUntil extends StringParserBuilder<String> {
  static const _template = '''
final {{pos}} = state.pos;
final {{index}} = source.indexOf({{tag}}, {{pos}});
state.ok = {{index}} >= 0;
if (state.ok) {
  state.pos = {{index}};
  {{res}} = {{pos}} == {{index}} ? '' : source.substring({{pos}}, {{index}});
} else if (!state.opt) {
  state.error = ErrExpected.tag({{pos}}, const Tag({{tag}}));
}''';

  final String tag;

  const TakeUntil(this.tag);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['index', 'pos']);
    return {
      'tag': helper.escapeString(tag),
      ...locals,
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
