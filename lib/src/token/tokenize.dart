part of '../../token.dart';

@experimental
class Tokenize<I extends Utf16Reader, O1, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.pos;
{{var1}}
{{p1}}
if (state.ok) {
  final v1 = {{pos}};
  final v2 = {{val1}};
  {{res0}} = {{tokenize}};
}''';

  static const _templateFast = '''
{{p1}}''';

  final ParserBuilder<I, O1> parser;

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
      'tokenize': fast ? '' : tokenize.build(context, 'tokenize', ['v1', 'v2']),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
