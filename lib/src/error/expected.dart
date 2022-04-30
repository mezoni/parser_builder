part of '../../error.dart';

class Expected<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{var1}}
{{p1}}
if (state.ok) {
  {{res0}} = {{res1}};
} else {
  state.error = ParseError.expected(state.pos, {{tag}});
}''';

  static const _templateFast = '''
{{p1}}
if (!state.ok) {
  state.error = ParseError.expected(state.pos, {{tag}});
}''';

  final ParserBuilder<I, O> parser;

  final String tag;

  const Expected(this.tag, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final r1 = context.getResult(parser, !fast);
    final values = {
      'p1': parser.build(context, r1),
      'tag': helper.escapeString(tag),
    };
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
