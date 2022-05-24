part of '../../error.dart';

@experimental
class FailMessage<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
state.fail({{pos}}, ParseError.message, {{message}});''';

  static const _templateWithStart = '''
state.fail({{pos}}, ParseError.message, {{message}}, {{start}});''';

  static const _templateWithStartEnd = '''
state.fail({{pos}}, ParseError.message, {{message}}, {{start}}, {{end}});''';

  final String? end;

  final String message;

  final String pos;

  final String? start;

  const FailMessage(this.pos, this.message, [this.start, this.end]);

  @override
  String build(Context context, ParserResult? result) {
    if (message.isEmpty) {
      throw ArgumentError.value(message, 'message', 'Must not be empty');
    }

    final values = {
      'end': end ?? StatePos.unknown,
      'message': helper.escapeString(message),
      'pos': pos,
      'start': start ?? StatePos.unknown,
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
