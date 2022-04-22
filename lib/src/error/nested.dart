part of '../../error.dart';

class Nested<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.pos;
{{var1}}
{{p1}}
if (state.ok) {
  {{res0}} = {{res1}};
} else if (state.log) {
  state.error = ErrNested({{pos}}, {{message}}, const Tag({{tag}}), state.error);
}''';

  static const _templateFast = '''
final {{pos}} = state.pos;
{{var1}}
{{p1}}
if (!state.ok && state.log) {
  state.error = ErrNested({{pos}}, {{message}}, const Tag({{tag}}), state.error);
}''';

  final String message;

  final ParserBuilder<I, O> parser;

  final String tag;

  const Nested(this.message, this.tag, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    final r1 = context.getResult(parser, !fast);
    values.addAll({
      'message': helper.escapeString(message),
      'p1': parser.build(context, r1),
      'tag': helper.escapeString(tag),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
