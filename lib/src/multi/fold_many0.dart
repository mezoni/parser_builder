part of '../../multi.dart';

class FoldMany0<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
var {{acc}} = {{initialize}};
final {{log}} = state.log;
state.log = false;
while (true) {
  {{var1}}
  {{p1}}
  if (!state.ok) {
    break;
  }
  final {{v}} = {{val1}};
  {{combine}};
}
state.log = {{log}};
state.ok = true;
if (state.ok) {
  {{res0}} = {{acc}};
}''';

  static const _templateFast = '''
final {{log}} = state.log;
state.log = false;
while (true) {
  {{p1}}
  if (!state.ok) {
    break;
  }
}
state.log = {{log}};
state.ok = true;''';

  final SemanticAction<O> combine;

  final SemanticAction<O> initialize;

  final ParserBuilder<I, O> parser;

  const FoldMany0(this.parser, this.initialize, this.combine);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = context.allocateLocals(['acc', 'log', 'v']);
    final r1 = context.getResult(parser, !fast);
    values.addAll({
      'combine':
          combine.build(context, 'combine', [values['acc']!, values['v']!]),
      'initialize': initialize.build(context, 'initialize', []),
      'p1': parser.build(context, r1),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
