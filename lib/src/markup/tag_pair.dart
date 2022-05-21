part of '../../markup.dart';

@experimental
class TagPair<O1, O2, O> extends ParserBuilder<String, O> {
  static const _template = r'''
final {{pos}} = state.pos;
{{var1}}
{{p1}}
if (state.ok) {
  {{var2}}
  {{p2}}
  if (state.ok) {
    final {{start}} = state.pos;
    {{var3}}
    {{p3}}
    if (state.ok) {
      final v1 = {{res1}};
      final v2 = {{res3}};
      state.ok = {{compare}};
      if (state.ok) {
        final v3 = {{res2}};
        final v4 = Result3(v1, v3, v2);
        {{res0}} = {{map}};
      } else {
        final message = "End tag '$v2' does not match start tag '$v1'";
        state.fail({{start}}, ParseError.message, message, state.pos);
      }
    }
  }
}
if (!state.ok) {
  state.pos = {{pos}};
}''';

  static const _templateFast = r'''
final {{pos}} = state.pos;
{{var1}}
{{p1}}
if (state.ok) {
  {{p2}}
  if (state.ok) {
    final {{start}} = state.pos;
    {{var3}}
    {{p3}}
    if (state.ok) {
      final v1 = {{res1}};
      final v2 = {{res3}};
      state.ok = {{compare}};
      if (!state.ok) {
        final message = "End tag '$v2' does not match start tag '$v1'";
        state.fail({{start}}, ParseError.message, message, state.pos);
      }
    }
  }
}
if (!state.ok) {
  state.pos = {{pos}};
}''';

  final SemanticAction<bool> compare;

  final ParserBuilder<String, O2> content;

  final ParserBuilder<String, O1> end;

  final SemanticAction<O> map;

  final ParserBuilder<String, O1> start;

  const TagPair(this.start, this.content, this.end, this.compare, this.map);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    final fast = result == null;
    final values = context.allocateLocals(['pos', 'start']);
    final r1 = context.getResult(start, true);
    final r2 = context.getResult(content, !fast);
    final r3 = context.getResult(end, true);
    values.addAll({
      'compare': compare.build(context, 'compare', ['v1', 'v2']),
      'map': map.build(context, 'map', ['v4']),
      'p1': start.build(context, r1),
      'p2': content.build(context, r2),
      'p3': end.build(context, r3),
    });
    return render2(
        fast, _templateFast, _template, values, [result, r1, r2, r3]);
  }
}
