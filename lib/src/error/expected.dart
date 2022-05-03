part of '../../error.dart';

/// Parses [parser] and returns the result of parsing.
///
/// This parser works as follows:
///
/// If a parsing errors occurs, then an `Expected(tag)` error is generated
/// instead of these errors.
class Expected<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{log}} = state.log;
state.log = false;
{{var1}}
{{p1}}
state.log = {{log}};
if (state.ok) {
  {{res0}} = {{res1}};
} else {
  state.error = ParseError.expected(state.pos, {{tag}});
}''';

  static const _templateFast = '''
final {{log}} = state.log;
state.log = false;
{{p1}}
state.log = {{log}};
if (!state.ok) {
  state.error = ParseError.expected(state.pos, {{tag}});
}''';

  final ParserBuilder<I, O> parser;

  final String tag;

  const Expected(this.tag, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['log']);
    final r1 = context.getResult(parser, !fast);
    values.addAll({
      'p1': parser.build(context, r1),
      'tag': helper.escapeString(tag),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
