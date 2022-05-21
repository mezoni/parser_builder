part of '../../error.dart';

@experimental
class SilentAtThisPos<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.minErrorPos;
state.minErrorPos = state.pos + 1;
{{p1}}
state.minErrorPos = {{pos}};''';

  final ParserBuilder<I, O> parser;

  const SilentAtThisPos(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final values = context.allocateLocals(['pos']);
    values.addAll({
      'p1': parser.build(context, result),
    });
    return render(_template, values, [result]);
  }
}
