part of '../../error.dart';

@experimental
class FailExpected<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
state.fail({{pos}}, ParseError.expected, {{value}});''';

  static const _templateWithStart = '''
state.fail({{pos}}, ParseError.expected, {{value}}, {{start}});''';

  final SemanticAction<int> pos;

  final SemanticAction<int>? start;

  final dynamic value;

  const FailExpected(this.pos, this.value, {this.start});

  @override
  String build(Context context, ParserResult? result) {
    if (start == null) {
      return _build(context, result);
    } else {
      return _buildWithStart(context, result);
    }
  }

  String _build(Context context, ParserResult? result) {
    final values = {
      'pos': pos.build(context, 'pos', []),
      'value': helper.getAsCode(value),
    };
    return render(_template, values);
  }

  String _buildWithStart(Context context, ParserResult? result) {
    final values = {
      'pos': pos.build(context, 'pos', []),
      'start': start!.build(context, 'start', []),
      'value': helper.getAsCode(value),
    };
    return render(_templateWithStart, values);
  }
}
