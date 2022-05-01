part of '../../combinator.dart';

class And<I> extends ParserBuilder<I, void> {
  static const _template = '''
final {{pos}} = state.pos;
final {{minErrorPos}} = state.minErrorPos;
state.minErrorPos = 0x7fffffff;
{{p1}}
state.minErrorPos = {{minErrorPos}};
if (state.ok) {
  state.pos = {{pos}};
} else {
  state.error = ParseError.message(state.pos, 0, 'Unknown error');
}''';

  final ParserBuilder<I, dynamic> parser;

  const And(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final values = context.allocateLocals(['minErrorPos', 'pos']);
    final r1 = context.getResult(parser, false);
    values.addAll({
      'p1': parser.build(context, r1),
    });
    return render(_template, values);
  }
}
