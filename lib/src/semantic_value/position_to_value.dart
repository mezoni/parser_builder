part of '../../semantic_value.dart';

class PositionToValue<I> extends ParserBuilder<I, void> {
  static const _template = '''
state.ok = true;
if (state.ok) {
  {{value}} = state.pos;
}''';

  final String name;

  const PositionToValue(this.name);

  @override
  String build(Context context, ParserResult? result) {
    final value = context.allocateSematicValue<int>(name);
    final values = {
      'value': value.name,
    };
    return render(_template, values);
  }
}
