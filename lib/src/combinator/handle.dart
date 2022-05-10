part of '../../combinator.dart';

@experimental
class Handle<I, O1, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{var1}}
{{p1}}
if (state.ok) {
  final v = {{val1}};
  {{res0}} = {{handle}};
}''';

  static const _templateFast = '''
{{var1}}
{{p1}}
if (state.ok) {
  final v = {{val1}};
  {{handle}};
}''';

  final SemanticAction<O> handle;

  final ParserBuilder<I, O1> parser;

  const Handle(this.parser, this.handle);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final r1 = context.getResult(parser, true);
    final values = {
      'handle': handle.build(context, 'handle', ['v']),
      'p1': parser.build(context, r1),
    };
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
