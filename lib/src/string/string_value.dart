part of '../../string.dart';

@experimental
class StringValue extends StringParserBuilder<String> {
  static const _template = '''
state.ok = true;
final {{buffer}} = StringBuffer();
final {{pos}} = state.pos;
{{transform}}
while (state.pos < source.length) {
  var {{start}} = state.pos;
  var {{c}} = 0;
  while (state.pos < source.length) {
    {{c}} = source.codeUnitAt(state.pos);
    {{c}} = {{c}} & 0xfc00 != 0xd800 ? {{c}} : source.runeAt(state.pos);
    if (!{{test}}({{c}})) {
      break;
    }
    state.pos += {{c}} > 0xffff ? 2 : 1;
  }
  if ({{start}} != state.pos) {
    {{buffer}}.write(source.substring({{start}}, state.pos));
  }
  if ({{c}} != {{controlChar}}) {
    break;
  }
  state.pos += {{size}};
  {{p1}}
  if (!state.ok) {
    state.pos = {{pos}};
    break;
  }
  {{buffer}}.writeCharCode({{p1_val}});
}
if (state.ok) {
  {{res}} = {{buffer}}.isEmpty ? '' : {{buffer}}.toString();
}''';

  final int controlChar;

  final Transformer<int, bool> normal;

  final ParserBuilder<String, int> escape;

  const StringValue(this.normal, this.controlChar, this.escape);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': escape,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    final locals =
        context.allocateLocals(['c', 'buffer', 'pos', 'start', 'test']);
    return {
      'controlChar': controlChar.toString(),
      'size': (controlChar > 0xffff ? 2 : 1).toString(),
      'transform': normal.transform(locals['test']!),
    }..addAll(locals);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([normal, controlChar, escape]);
  }
}
