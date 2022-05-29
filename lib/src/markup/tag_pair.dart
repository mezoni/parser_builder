part of '../../markup.dart';

@experimental
class TagPair<I extends Utf16Reader, O1, O2, O> extends ParserBuilder<I, O> {
  static const _template = r'''
final {{pos}} = state.pos;
{{var1}}
{{p1}}
if (state.ok) {
  final {{end}} = state.pos;
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
        final message1 = "Start tag '$v1' does not match end tag '$v2'";
        final message2 = "End tag '$v2' does not match start tag '$v1'";
        state.fail(state.pos, ParseError.message, message1, {{pos}}, {{end}});
        state.fail(state.pos, ParseError.message, message2, {{start}}, state.pos);
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
  final {{end}} = state.pos;
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
        final message1 = "Start tag '$v1' does not match end tag '$v2'";
        final message2 = "End tag '$v2' does not match start tag '$v1'";
        state.fail(state.pos, ParseError.message, message1, {{pos}}, {{end}});
        state.fail(state.pos, ParseError.message, message2, {{start}}, state.pos);
      }
    }
  }
}
if (!state.ok) {
  state.pos = {{pos}};
}''';

  final SemanticAction<bool> compare;

  final ParserBuilder<I, O2> content;

  final ParserBuilder<I, O1> end;

  final SemanticAction<O> map;

  final ParserBuilder<I, O1> start;

  const TagPair(this.start, this.content, this.end, this.compare, this.map);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    final fast = result == null;
    final values = context.allocateLocals(['end', 'pos', 'start']);
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
