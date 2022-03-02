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
state.ok = {{index}} != -1;
if (state.ok) {
  state.pos = {{index}};
  {{res}} = source.substring({{pos}}, {{index}});
} else {
  state.error = ErrExpected.tag({{pos}}, const Tag({{tag}}));
}''';

  final String tag;

  const TakeUntil(this.tag);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['pos', 'index']);
    return {
      'tag': helper.escapeString(tag),
    }..addAll(locals);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
