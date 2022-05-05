part of '../../error.dart';

/// Parses [parser] and returns the result of parsing.
///
/// This parser works as follows:
///
/// If a parsing errors occurs at the start position, then an `Expected(tag)`
/// error is generated instead of these errors.
///
/// If a parsing errors occurs at the next positions, then all other errors are
/// generated as well.
class Nested<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{min}} = state.minErrorPos;
state.minErrorPos = state.pos + 1;
{{var1}}
{{p1}}
state.minErrorPos = {{min}};
if (state.ok) {
  {{res0}} = {{res1}};
} else {
  state.fail(state.pos, ParseError.expected, 0, {{tag}});
}''';

  static const _templateFast = '''
final {{min}} = state.minErrorPos;
state.minErrorPos = state.pos + 1;
{{p1}}
state.minErrorPos = {{min}};
if (!state.ok) {
  state.fail(state.pos, ParseError.expected, 0, {{tag}});
}''';

  final ParserBuilder<I, O> parser;

  final String tag;

  const Nested(this.tag, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['min']);
    final r1 = context.getResult(parser, !fast);
    values.addAll({
      'p1': parser.build(context, r1),
      'tag': helper.escapeString(tag),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
