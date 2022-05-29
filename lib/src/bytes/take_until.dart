part of '../../bytes.dart';

/// Parses until the first occurrence of a [tag] is found and returns a
/// substring up to the found [tag].
///
/// Example
/// ```dart
/// TakeUntil('{{')
/// ```
class TakeUntil extends ParserBuilder<Utf16Reader, String> {
  static const _template = '''
final {{pos}} = state.pos;
final {{index}} = source.indexOf({{tag}}, {{pos}});
state.ok = {{index}} >= 0;
if (state.ok) {
  state.pos = {{index}};
  {{res0}} = source.substring({{pos}}, {{index}});
} else {
  state.fail({{pos}}, ParseError.expected, {{tag}});
}''';

  static const _templateFast = '''
final {{pos}} = state.pos;
final {{index}} = source.indexOf({{tag}}, {{pos}});
state.ok = {{index}} >= 0;
if (state.ok) {
  state.pos = {{index}};
} else {
  state.fail({{pos}}, ParseError.expected, {{tag}});
}''';

  final String tag;

  const TakeUntil(this.tag);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    ParseRuntime.addClassUtf16Reader(context);
    final fast = result == null;
    final values = context.allocateLocals(['index', 'pos']);
    values.addAll({
      'tag': helper.escapeString(tag),
    });
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
