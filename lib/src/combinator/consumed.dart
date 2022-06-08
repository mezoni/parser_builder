part of '../../combinator.dart';

class Consumed<I, O> extends ParserBuilder<I, Result2<I, O>> {
  static const _template = '''
final {{pos}} = state.pos;
{{var1}}
{{p1}}
if (state.ok) {
  final v = source.slice({{pos}}, state.pos);
  {{res0}} = Result2(v, {{val1}});
}''';

  static const _templateFast = '''
{{p1}}''';

  final ParserBuilder<I, O> parser;

  const Consumed(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    final fast = result == null;
    ParseRuntime.addCapability(context, ParseRuntimeCapability.result2, !fast);
    final values = context.allocateLocals(['pos']);
    final r1 = context.getResult(parser, true);
    values.addAll({
      'p1': parser.build(context, r1),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
