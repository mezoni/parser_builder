part of '../../bytes.dart';

/// Parses until the first occurrence of a [tag] is found and returns a
/// substring up to the found [tag].
///
/// Example
/// ```dart
/// TakeUntil('{{')
/// ```
class TakeUntil extends ParserBuilder<String, String> {
  static const _template = '''
final {{pos}} = state.pos;
final {{index}} = source.indexOf({{tag}}, {{pos}});
state.ok = {{index}} >= 0;
if (state.ok) {
  state.pos = {{index}};
  {{res0}} = source.substring({{pos}}, {{index}});
} else if (state.log) {
  state.error = ErrExpected.tag({{pos}}, const Tag({{tag}}));
}''';

  static const _templateFast = '''
final {{pos}} = state.pos;
final {{index}} = source.indexOf({{tag}}, {{pos}});
state.ok = {{index}} >= 0;
if (state.ok) {
  state.pos = {{index}};
} else if (state.log) {
  state.error = ErrExpected.tag({{pos}}, const Tag({{tag}}));
}''';

  final String tag;

  const TakeUntil(this.tag);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    final fast = result == null;
    final values = context.allocateLocals(['index', 'pos']);
    values.addAll({
      'tag': helper.escapeString(tag),
    });
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
