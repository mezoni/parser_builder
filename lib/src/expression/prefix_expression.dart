part of '../../expression.dart';

class PrefixExpression<I, O1, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.pos;
{{var1}}
{{p1}}
final {{ok}} = state.ok;
{{var2}}
{{p2}}
if (state.ok) {
  if ({{ok}}) {
    final v1 = {{val1}};
    final v2 = {{val2}};
    {{res0}} = {{calculate}};
  } else {
    {{res0}} = {{val2}};
  }
} else {
  state.pos = {{pos}};
}''';

  static const _templateFast = '''
final {{pos}} = state.pos;
{{var1}}
{{p1}}
final {{ok}} = state.ok;
{{var2}}
{{p2}}
if (!state.ok) {
  state.pos = {{pos}};
}''';

  final SemanticAction<O> calculate;

  final ParserBuilder<I, O> expression;

  final ParserBuilder<I, O1> operator;

  const PrefixExpression(this.operator, this.expression, this.calculate);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['ok', 'pos']);
    final r1 = context.getResult(operator, !fast);
    final r2 = context.getResult(expression, !fast);
    values.addAll({
      'calculate': calculate.build(context, 'calculate', ['v1', 'v2']),
      'p1': Silent(operator).build(context, r1),
      'p2': expression.build(context, r2),
    });
    return render2(fast, _templateFast, _template, values, [result, r1, r2]);
  }
}
