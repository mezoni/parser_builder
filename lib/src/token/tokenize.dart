part of '../../token.dart';

@experimental
class Tokenize<O1, O> extends ParserBuilder<String, O> {
  static const _template = '''
final {{pos}} = state.pos;
{{var1}}
{{p1}}
if (state.ok) {
  final v1 = source;
  final v2 = {{pos}};
  final v3 = state.pos;
  final v4 = {{val1}};
  {{res0}} = {{tokenize}};
}''';

  static const _templateFast = '''
{{p1}}''';

  final ParserBuilder<String, O1> parser;

  final SemanticAction<O> tokenize;

  const Tokenize(this.parser, this.tokenize);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    final r1 = context.getResult(parser, !fast);
    values.addAll({
      'p1': parser.build(context, r1),
      'tokenize': fast
          ? ''
          : tokenize.build(context, 'tokenize', ['v1', 'v2', 'v3', 'v4']),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
