part of '../../error.dart';

@experimental
class FailExpected<I, O> extends _Fail<I, O> {
  static const _template = '''
state.ok = false;
state.fail({{pos}}, ParseError.expected, {{value}});''';

  static const _templateWithStart = '''
state.ok = false;
state.fail({{pos}}, ParseError.expected, {{value}}, {{start}});''';

  final FailPos pos;

  final FailPos? start;

  final dynamic value;

  const FailExpected(this.pos, this.value, {this.start});

  @override
  String build(Context context, ParserResult? result) {
    final hasStart = start != null;
    final values = {
      'pos': _getFailPos(pos),
      'start': _getFailPos(start),
      'value': helper.getAsCode(value),
    };
    return render2(hasStart, _templateWithStart, _template, values);
  }
}
