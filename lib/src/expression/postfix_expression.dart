part of '../../expression.dart';

class PostfixExpression<I, O1, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{var1}}
{{p1}}
if (state.ok) {
  final {{log}} = state.log;
  state.log = false;
  {{var2}}
  {{p2}}
  state.log = {{log}};
  if (state.ok) {
    final v1 = {{val1}};
    final v2 = {{val2}};
    {{res0}} = {{calculate}};
  } else {
    state.ok = true;
    {{res0}} = {{val1}};
  }
}''';

  static const _templateFast = '''
{{p1}}
if (state.ok) {
  final {{log}} = state.log;
  state.log = false;
  {{p2}}
  state.log = {{log}};
  state.ok = true;
}''';

  final SemanticAction<O> calculate;

  final ParserBuilder<I, O> expression;

  final ParserBuilder<I, O1> operator;

  const PostfixExpression(this.expression, this.operator, this.calculate);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['log']);
    final r1 = context.getResult(expression, !fast);
    final r2 = context.getResult(operator, !fast);
    values.addAll({
      'calculate': calculate.build(context, 'calculate', ['v1', 'v2']),
      'p1': expression.build(context, r1),
      'p2': operator.build(context, r2),
    });
    return render2(fast, _templateFast, _template, values, [result, r1, r2]);
  }
}
