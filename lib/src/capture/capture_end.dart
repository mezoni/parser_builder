part of '../../capture.dart';

class CaptureEnd<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{p1}}
{{value}} = state.pos;''';

  final Object key;

  final ParserBuilder<I, O> parser;

  const CaptureEnd(this.key, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final value = context.allocateSematicValue<int>(key);
    final values = {
      'p1': parser.build(context, result),
      'value': value.name,
    };
    return render(_template, values);
  }
}
