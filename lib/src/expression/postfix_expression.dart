part of '../../expression.dart';

class PostfixExpression<I, O1, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{var1}}
{{p1}}
if (state.ok) {
  {{var2}}
  {{p2}}
  if ({{res2}} != null) {
    final v1 = {{val1}};
    final v2 = {{res2}};
    {{res0}} = {{calculate}};
  } else {
    {{res0}} = {{val1}};
  }
}''';

  static const _templateFast = '''
{{p1}}
if (state.ok) {
  {{p2}}
}''';

  final SemanticAction<O> calculate;

  final ParserBuilder<I, O> expression;

  final ParserBuilder<I, O1> operator;

  const PostfixExpression(this.expression, this.operator, this.calculate);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final r1 = context.getResult(expression, !fast);
    final r2 = context.getResult(operator, !fast);
    final values = {
      'calculate': calculate.build(context, 'calculate', ['v1', 'v2']),
      'p1': expression.build(context, r1),
      'p2': Opt(operator).build(context, r2),
    };
    return render2(fast, _templateFast, _template, values, [result, r1, r2]);
  }
}
