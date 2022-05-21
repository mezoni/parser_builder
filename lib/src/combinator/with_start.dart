part of '../../combinator.dart';

@experimental
class WithStart<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.start;
state.start = state.pos;
{{p1}}
state.start = {{pos}};''';

  final ParserBuilder<I, O> parser;

  const WithStart(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final values = context.allocateLocals(['pos']);
    values.addAll({
      'p1': parser.build(context, result),
    });
    return render(_template, values, [result]);
  }
}
