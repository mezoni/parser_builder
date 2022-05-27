part of '../../capture.dart';

class CapturePosition<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
state.ok = true;
{{value}} = state.pos;''';

  final Object key;

  const CapturePosition(this.key);

  @override
  String build(Context context, ParserResult? result) {
    final value = context.allocateSematicValue<int>(key);
    final values = {
      'value': value.name,
    };
    return render(_template, values);
  }
}
