part of '../../capture.dart';

class CaptureResult<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{p1}}
{{value}} = {{res0}};''';

  static const _templateFast = '''
{{var0}}
{{p0}}
{{value}} = {{res0}};''';

  final Object key;

  final ParserBuilder<I, O> parser;

  const CaptureResult(this.key, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final value = context.allocateSematicValue<O>(key);
    final r1 = fast ? context.getResult(parser, true) : result;
    final values = {
      'p0': Slow(parser).build(context, r1),
      'value': value.name,
    };
    return render2(fast, _templateFast, _template, values, [r1]);
  }
}
