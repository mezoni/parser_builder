part of '../../error.dart';

@experimental
class FailCharacter<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
state.fail({{pos}}, ParseError.character);''';

  static const _templateWithStart = '''
state.fail({{pos}}, ParseError.character, null, {{start}});''';

  final String pos;

  final String? start;

  const FailCharacter(this.pos, [this.start]);

  @override
  String build(Context context, ParserResult? result) {
    final hasStart = start != null;
    final values = {
      'pos': context.renderSemanticValues(pos),
      'start': context.renderSemanticValues(start ?? StatePos.unknown),
    };
    return render2(hasStart, _templateWithStart, _template, values);
  }
}
