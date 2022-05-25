part of '../../error.dart';

@experimental
class FailCharacter<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
state.fail({{pos}}, ParseError.character);''';

  static const _templateWithStart = '''
state.fail({{pos}}, ParseError.character, null, {{start}});''';

  final SemanticAction<int> pos;

  final SemanticAction<int>? start;

  const FailCharacter(this.pos, [this.start]);

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
      'start': start!.build(context, 'start', []),
    };
    return render(_template, values);
  }

  String _buildWithStart(Context context, ParserResult? result) {
    final values = {
      'pos': pos.build(context, 'pos', []),
      'start': start!.build(context, 'start', []),
    };
    return render(_templateWithStart, values);
  }
}
