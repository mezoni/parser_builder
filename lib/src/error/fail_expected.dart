part of '../../error.dart';

@experimental
class FailExpected<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
state.fail({{pos}}, ParseError.expected, {{value}});''';

  static const _templateWithStart = '''
state.fail({{pos}}, ParseError.expected, {{value}}, {{start}});''';

  final String pos;

  final String? start;

  final dynamic value;

  const FailExpected(this.pos, this.value, {this.start});

  @override
  String build(Context context, ParserResult? result) {
    final hasStart = start != null;
    final values = {
      'pos': context.renderSemanticValues(pos),
      'start': context.renderSemanticValues(start ?? StatePos.unknown),
      'value': helper.getAsCode(value),
    };
    return render2(hasStart, _templateWithStart, _template, values);
  }
}
