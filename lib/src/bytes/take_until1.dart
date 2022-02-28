part of '../../bytes.dart';

/// Parses until the first occurrence of a [tag] is found, and returns a slice
/// up to the found [tag] if the slice is not empty.
///
/// Example
/// ```dart
/// TakeUntil1('{{')
/// ```
class TakeUntil1 extends StringParserBuilder<String> {
  static const _template = '''
final {{start}} = state.pos;
final {{index}} = source.indexOf({{tag}}, {{start}});
if ({{index}} > {{start}}) {
  state.ok = true;
  state.readChar({{index}});
  {{res}} = source.slice({{start}}, {{index}});
} else {
  state.ok = false;
  state.error = ErrExpected.tag(state.pos, const Tag({{tag}}));
}''';

  final String tag;

  const TakeUntil1(this.tag);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['start', 'index']);
    return {
      'tag': helper.escapeString(tag),
    }..addAll(locals);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
