part of '../../expression.dart';

class BinaryExpression<I, O1, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{O}} {{left}};
var {{ok}} = false;
{{var1}}
{{p1}}
if (state.ok) {
  {{ok}} = true;
  {{left}} = {{res1}};
  while (true) {
    final {{pos}} = state.pos;
    {{var2}}
    {{p2}}
    if (!state.ok) {
      break;
    }
    {{var3}}
    {{p3}}
    if (!state.ok) {
      {{ok}} = false;
      state.pos = {{pos}};
      break;
    }
    final {{op}} = {{val2}};
    final {{right}} = {{val3}};
    {{left}} = {{calculate}};
  }
}
state.ok = {{ok}};
if (state.ok) {
  {{res0}} = {{left}};
}''';

  static const _templateFast = '''
{{O}} {{left}};
var {{ok}} = false;
{{var1}}
{{p1}}
if (state.ok) {
  {{ok}} = true;
  {{left}} = {{res1}};
  while (true) {
    final {{pos}} = state.pos;
    {{var2}}
    {{p2}}
    if (!state.ok) {
      break;
    }
    {{var3}}
    {{p3}}
    if (!state.ok) {
      {{ok}} = false;
      state.pos = {{pos}};
      break;
    }
    final {{op}} = {{val2}};
    final {{right}} = {{val3}};
    {{left}} = {{calculate}};
  }
}
state.ok = {{ok}};''';

  final SemanticAction<O> calculate;

  final ParserBuilder<I, O> left;

  final ParserBuilder<I, O1> operator;

  final ParserBuilder<I, O> right;

  const BinaryExpression(this.left, this.operator, this.right, this.calculate);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['left', 'ok', 'op', 'pos', 'right']);
    final r1 = context.getResult(left, !fast);
    final r2 = context.getResult(operator, !fast);
    final r3 = context.getResult(right, !fast);
    values.addAll({
      'calculate': calculate.build(context, 'calculate', [
        left.getResultValue(values['left']!),
        values['op']!,
        values['right']!,
      ]),
      'O': left.getResultType(),
      'p1': left.build(context, r1),
      'p2': operator.build(context, r2),
      'p3': right.build(context, r3),
    });
    return render2(
        fast, _templateFast, _template, values, [result, r1, r2, r3]);
  }
}
