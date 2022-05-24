part of '../../error.dart';

@experimental
class HandleLastErrorPos<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{pos}} = state.setLastErrorPos(-1);
{{p1}}
state.restoreLastErrorPos({{pos}});''';

  final ParserBuilder<I, O> parser;

  const HandleLastErrorPos(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final values = context.allocateLocals(['pos']);
    values.addAll({
      'p1': parser.build(context, result),
    });
    return render(_template, values, [result]);
  }
}
