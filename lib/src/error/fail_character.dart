part of '../../error.dart';

@experimental
class FailCharacter<I, O> extends _Fail<I, O> {
  static const _template = '''
state.fail({{pos}}, ParseError.character, null);''';

  static const _templateWithStart = '''
state.fail({{pos}}, ParseError.character, start: {{start}});''';

  final StatePos pos;

  final StatePos? start;

  const FailCharacter(this.pos, [this.start]);

  @override
  String build(Context context, ParserResult? result) {
    final hasStart = start != null;
    final values = {
      'pos': _getFailPos(pos),
      'start': _getFailPos(start),
    };
    return render2(hasStart, _templateWithStart, _template, values);
  }
}
