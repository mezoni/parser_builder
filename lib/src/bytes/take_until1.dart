part of '../../bytes.dart';

/// Parses until the first occurrence of a [tag] is found, and returns a
/// substring up to the found [tag] if the substring is not empty.
///
/// Example
/// ```dart
/// TakeUntil1('{{')
/// ```
class TakeUntil1 extends ParserBuilder<String, String> {
  static const _template = '''
final {{pos}} = state.pos;
final {{index}} = source.indexOf({{tag}}, {{pos}});
state.ok = {{index}} > {{pos}};
if (state.ok) {
  state.pos = {{index}};
  {{res0}} = source.substring({{pos}}, {{index}});
} else {
  if ({{index}} == -1) {
    state.error = ParseError.expected(source.length, {{tag}});
  } else {
    state.error = ParseError.unexpected({{pos}}, 0, {{tag}});
  }
}''';

  static const _templateFast = '''
final {{pos}} = state.pos;
final {{index}} = source.indexOf({{tag}}, {{pos}});
state.ok = {{index}} > {{pos}};
if (state.ok) {
  state.pos = {{index}};
} else {
  if ({{index}} == -1) {
    state.error = ParseError.expected(source.length, {{tag}});
  } else {
    state.error = ParseError.unexpected({{pos}}, 0, {{tag}});
  }
}''';

  final String tag;

  const TakeUntil1(this.tag);

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
