part of '../../combinator.dart';

class Recognize<I> extends ParserBuilder<I, I> {
  static const _template = '''
final {{pos}} = state.pos;
{{p1}}
if (state.ok) {
  {{res0}} = source.slice({{pos}}, state.pos);
}''';

  static const _templateFast = '''
{{p1}}''';

  final ParserBuilder<I, dynamic> parser;

  const Recognize(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    values.addAll({
      'p1': parser.build(context, null),
    });
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
