part of '../../string.dart';

class CharSequence extends StringParserBuilder<List<int>> {
  static const _template = '''
final {{list}} = <int>[];
state.ok = true;
{{transform}}
while (true) {
  if (state.pos >= source.length) {
    break;
  }
  var {{c}} = source.codeUnitAt(state.pos);
  {{c}} = {{c}} <= 0xD7FF || {{c}} >= 0xE000 ? {{c}} : source.runeAt(state.pos);
  if ({{test}}({{c}})) {
    {{list}}.add({{c}});
    state.pos += {{c}} > 0xffff ? 2 : 1;
    continue;
  }
  if ({{c}} != {{controlChar}}) {
    break;
  }
  final pos = state.pos;
  state.pos += {{c}} > 0xffff ? 2 : 1;
  {{p1}}
  if (!state.ok) {
    state.pos = pos;
    break;
  }
  {{list}}.add({{p1_val}});
}
if (state.ok) {
  {{res}} = {{list}};
}''';

  final int controlChar;

  final Transformer<int, bool> normal;

  final ParserBuilder<String, int> escape;

  const CharSequence(this.normal, this.controlChar, this.escape);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': escape,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['list', 'test', 'c']);
    return {
      'controlChar': controlChar.toString(),
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
