part of '../../combinator.dart';

class Not<I> extends ParserBuilder<I, void> {
  static const _template = '''
final {{pos}} = state.pos;
state.errorPos = 0x7fffffff;
{{p1}}
state.restoreErrorPos();
state.ok = !state.ok;
if (!state.ok) {
  state.pos = {{pos}};
  state.error = ParseError.message(state.pos, 0, 'Unknown error');
}''';

  final ParserBuilder<I, dynamic> parser;

  const Not(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final values = context.allocateLocals(['pos']);
    values.addAll({
      'p1': parser.build(context, null),
    });
    return render(_template, values, [result]);
  }
}
