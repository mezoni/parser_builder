part of '../../combinator.dart';

class Verify<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{var1}}
{{p1}}
if (state.ok) {
  final v = {{val1}};
  state.ok = {{verify}};
  if (state.ok) {
    {{res0}} = v;
  }
}''';

  static const _templateFast = '''
{{var1}}
{{p1}}
if (state.ok) {
  final v = {{val1}};
  state.ok = {{verify}};
}''';

  final String message;

  final ParserBuilder<I, O> parser;

  final SemanticAction<bool> verify;

  const Verify(this.message, this.parser, this.verify);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final r1 = context.getResult(parser, true);
    final values = {
      'p1': parser.build(context, r1),
      'verify': verify.build(context, 'verify', ['v']),
    };
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
