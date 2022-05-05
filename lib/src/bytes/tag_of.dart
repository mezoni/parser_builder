part of '../../bytes.dart';

class TagOf extends ParserBuilder<String, String> {
  static const _template = '''
{{var1}}
{{p1}}
if (state.ok) {
  final tag = {{val1}};
  state.ok = source.startsWith(tag, state.pos);
  if (state.ok) {
    state.pos += tag.length;
    {{res0}} = tag;
  } else {
    state.fail(state.pos, ParseError.expected, 0, tag);
  }
}''';

  static const _templateFast = '''
{{var1}}
{{p1}}
if (state.ok) {
  final tag = {{val1}};
  state.ok = source.startsWith(tag, state.pos);
  if (state.ok) {
    state.pos += tag.length;
  } else {
    state.fail(state.pos, ParseError.expected, 0, tag);
  }
}''';

  final ParserBuilder<String, String> tag;

  const TagOf(this.tag);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    final fast = result == null;
    final r1 = context.getResult(tag, true);
    final values = {
      'p1': tag.build(context, r1),
    };
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
