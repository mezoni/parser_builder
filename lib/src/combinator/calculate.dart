part of '../../combinator.dart';

class Calculate<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
state.ok = true;
if (state.ok) {
  {{res0}} = {{calculate}};
}''';

  static const _templateFast = '''
state.ok = true;''';

  final SemanticAction<O> calculate;

  const Calculate(this.calculate);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = {
      'calculate': fast ? '' : calculate.build(context, 'calculate', []),
    };
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
