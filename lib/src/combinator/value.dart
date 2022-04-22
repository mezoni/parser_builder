part of '../../combinator.dart';

class Value<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
state.ok = true;
if (state.ok) {
  {{res0}} = {{value}};
}''';

  static const _templateFast = '''
state.ok = true;''';

  static const _templateParser = '''
{{p1}}
if (state.ok) {
  {{res0}} = {{value}};
}''';

  static const _templateParserFast = '''
{{p1}}''';

  final ParserBuilder<I, dynamic>? parser;

  final O value;

  const Value(this.value, [this.parser]);

  @override
  String build(Context context, ParserResult? result) {
    if (parser != null) {
      return _buildWithParser(context, result);
    } else {
      return _build(context, result);
    }
  }

  String _build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = {
      'value': helper.getAsCode(value),
    };
    return render2(fast, _templateFast, _template, values, [result]);
  }

  String _buildWithParser(Context context, ParserResult? result) {
    final fast = result == null;
    final values = {
      'p1': parser!.build(context, null),
      'value': helper.getAsCode(value),
    };
    return render2(
        fast, _templateParserFast, _templateParser, values, [result]);
  }
}
