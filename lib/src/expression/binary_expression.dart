part of '../../expression.dart';

class BinaryExpression<I, O1, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{list}} = <Tuple2<{{O1}}, {{O}}>>[];
var {{ok}} = false;
{{var1}}
{{p1}}
if (state.ok) {
  {{ok}} = true;
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
      state.pos = {{pos}};
      break;
    }
    {{list}}.add(Tuple2({{val2}}, {{val3}}));
  }
}
state.ok = {{ok}};
if (state.ok) {
  var left = {{val1}};
  for (var i = 0; i < {{list}}.length; i++) {
    final v = {{list}}[i];
    left = {{reduce}};
  }
  {{res0}} = left;
}''';

  static const _templateFast = '''
final {{list}} = <Tuple2<{{O1}}, {{O}}>>[];
var {{ok}} = false;
{{var1}}
{{p1}}
if (state.ok) {
  {{ok}} = true;
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
      state.pos = {{pos}};
      break;
    }
    {{list}}.add(Tuple2({{val2}}, {{val3}}));
  }
}
state.ok = {{ok}};
if (state.ok) {
  var left = {{val1}};
  for (var i = 0; i < {{list}}.length; i++) {
    final v = {{list}}[i];
    left = {{reduce}};
  }
}''';

  final SemanticAction<O> calculate;

  final ParserBuilder<I, O> left;

  final ParserBuilder<I, O1> operator;

  final ParserBuilder<I, O> right;

  const BinaryExpression(this.left, this.operator, this.right, this.calculate);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['list', 'ok', 'pos']);
    final r1 = context.getResult(left, !fast);
    final r2 = context.getResult(operator, !fast);
    final r3 = context.getResult(right, !fast);
    values.addAll({
      'O': '$O',
      'O1': '$O1',
      'p1': left.build(context, r1),
      'p2': operator.build(context, r2),
      'p3': right.build(context, r3),
      'reduce':
          calculate.build(context, 'calculate', ['left', 'v.item1', 'v.item2']),
    });
    return render2(
        fast, _templateFast, _template, values, [result, r1, r2, r3]);
  }
}
