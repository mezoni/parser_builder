part of '../../error.dart';

class Nested<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{nested}} = state.nested;
state.nested = state.pos;
{{var1}}
{{p1}}
state.nested = {{nested}};
if (state.ok) {
  {{res0}} = {{res1}};
} else {
  state.error = ParseError.expected(state.pos, {{tag}});
}''';

  static const _templateFast = '''
final {{nested}} = state.nested;
state.nested = state.pos;
{{p1}}
state.nested = {{nested}};
if (!state.ok) {
  state.error = ParseError.expected(state.pos, {{tag}});
}''';

  final ParserBuilder<I, O> parser;

  final String tag;

  const Nested(this.tag, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['nested']);
    final r1 = context.getResult(parser, !fast);
    values.addAll({
      'p1': parser.build(context, r1),
      'tag': helper.escapeString(tag),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
