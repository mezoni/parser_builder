part of '../../error.dart';

@experimental
class FailMessage<I, O> extends _Fail<I, O> {
  static const _template = '''
state.ok = false;
state.fail({{pos}}, ParseError.message, {{message}});''';

  static const _templateWithStart = '''
state.ok = false;
state.fail({{pos}}, ParseError.message, {{message}}, {{start}});''';

  final String message;

  final FailPos pos;

  final FailPos? start;

  const FailMessage(this.pos, this.message, [this.start]);

  @override
  String build(Context context, ParserResult? result) {
    if (message.isEmpty) {
      throw ArgumentError.value(message, 'message', 'Must not be empty');
    }

    final hasStart = start != null;
    final values = {
      'message': helper.escapeString(message),
      'pos': _getFailPos(pos),
      'start': _getFailPos(start),
    };
    return render2(hasStart, _templateWithStart, _template, values);
  }
}
