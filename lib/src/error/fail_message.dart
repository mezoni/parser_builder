part of '../../error.dart';

@experimental
class FailMessage<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
state.fail({{pos}}, ParseError.message, {{message}});''';

  static const _templateWithStart = '''
state.fail({{pos}}, ParseError.message, {{message}}, {{start}});''';

  static const _templateWithStartEnd = '''
state.fail({{pos}}, ParseError.message, {{message}}, {{start}}, {{end}});''';

  final SemanticAction<int>? end;

  final String message;

  final SemanticAction<int> pos;

  final SemanticAction<int>? start;

  const FailMessage(this.pos, this.message, [this.start, this.end]);

  @override
  String build(Context context, ParserResult? result) {
    if (message.isEmpty) {
      throw ArgumentError.value(message, 'message', 'Must not be empty');
    }

    if (start == null) {
      return _build(context, result);
    } else {
      if (end == null) {
        return _buildWithStart(context, result);
      } else {
        return _buildWithStartEnd(context, result);
      }
    }
  }

  String _build(Context context, ParserResult? result) {
    final values = {
      'message': helper.escapeString(message),
      'pos': pos.build(context, 'pos', []),
    };
    return render(_template, values);
  }

  String _buildWithStart(Context context, ParserResult? result) {
    final values = {
      'message': helper.escapeString(message),
      'pos': pos.build(context, 'pos', []),
      'start': start!.build(context, 'start', []),
    };
    return render(_templateWithStart, values);
  }

  String _buildWithStartEnd(Context context, ParserResult? result) {
    final values = {
      'end': end!.build(context, 'end', []),
      'message': helper.escapeString(message),
      'pos': pos.build(context, 'pos', []),
      'start': start!.build(context, 'start', []),
    };
    return render(_templateWithStartEnd, values);
  }
}
