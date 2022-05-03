part of '../../combinator.dart';

class And<I> extends ParserBuilder<I, void> {
  static const _template = '''
final {{pos}} = state.pos;
state.log = false;
{{p1}}
state.log = true;
if (state.ok) {
  state.pos = {{pos}};
} else {
  state.error = ParseError.message(state.pos, 0, 'Unknown error');
}''';

  final ParserBuilder<I, dynamic> parser;

  const And(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final values = context.allocateLocals(['pos']);
    final r1 = context.getResult(parser, false);
    values.addAll({
      'p1': parser.build(context, r1),
    });
    return render(_template, values);
  }
}
