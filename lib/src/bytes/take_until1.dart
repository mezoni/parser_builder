part of '../../bytes.dart';

/// Parses until the first occurrence of a [tag] is found, and returns a
/// substring up to the found [tag] if the substring is not empty.
///
/// Example
/// ```dart
/// TakeUntil1('{{')
/// ```
class TakeUntil1 extends StringParserBuilder<String> {
  static const _template = '''
final {{pos}} = state.pos;
final {{index}} = source.indexOf({{tag}}, {{pos}});
state.ok = {{index}} > {{pos}};
if (state.ok) {
  state.pos = {{index}};
  {{res}} = source.substring({{pos}}, {{index}});
} else if (!state.opt) {
  state.error = ErrExpected.tag({{pos}}, const Tag({{tag}}));
}''';

  final String tag;

  const TakeUntil1(this.tag);

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
