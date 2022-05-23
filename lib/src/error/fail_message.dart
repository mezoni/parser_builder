part of '../../error.dart';

@experimental
class FailMessage<I, O> extends _Fail<I, O> {
  static const _template = '''
state.fail({{pos}}, ParseError.message, {{message}});''';

  static const _templateWithStart = '''
state.fail({{pos}}, ParseError.message, {{message}}, {{start}});''';

  static const _templateWithStartEnd = '''
state.fail({{pos}}, ParseError.message, {{message}}, {{start}}, {{end}});''';

  final StatePos? end;

  final String message;

  final StatePos pos;

  final StatePos? start;

  const FailMessage(this.pos, this.message, [this.start, this.end]);

  @override
  String build(Context context, ParserResult? result) {
    if (message.isEmpty) {
      throw ArgumentError.value(message, 'message', 'Must not be empty');
    }

    final values = {
      'end': _getFailPos(end),
      'message': helper.escapeString(message),
      'pos': _getFailPos(pos),
      'start': _getFailPos(start),
    };
    final String template;
    if (start == null) {
      template = _template;
    } else {
      if (end == null) {
        template = _templateWithStart;
      } else {
        template = _templateWithStartEnd;
      }
    }

    return render(template, values);
  }
}
