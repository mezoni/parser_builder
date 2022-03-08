part of '../../multi.dart';

class FoldMany0<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
final {{opt}} = state.opt;
state.opt = true;
var {{acc}} = {{init}};
{{transform1}}
{{transform2}}
for (;;) {
  {{p1}}
  if (!state.ok) {
    break;
  }
  final v = {{p1_val}};
  {{combine}};
}
state.ok = true;
if (state.ok) {
  {{res}} = {{acc}};
}
state.opt = {{opt}};''';

  final Transformer<O> combine;

  final Transformer<O> initialize;

  final ParserBuilder<I, O> parser;

  const FoldMany0(this.parser, this.initialize, this.combine);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['acc', 'opt']);
    final acc = locals['acc']!;
    final t1 = Transformation(context: context, name: 'init', arguments: []);
    final t2 = Transformation(
        context: context, name: 'combine', arguments: [acc, 'v']);
    return {
      'O': O.toString(),
      ...locals,
      'transform1': initialize.declare(t1),
      'init': initialize.invoke(t1),
      'transform2': combine.declare(t2),
      'combine': combine.invoke(t2),
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([parser]);
  }
}
