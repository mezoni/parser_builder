part of '../../string.dart';

class CharSequence extends ParserBuilder<String, List<int>> {
  static const _template = '''
final {{list}} = <int>[];
state.ok = true;
{{transform}}
while (true) {
  if (state.ch == State.eof) {
    break;
  }
  if ({{test}}(state.ch)) {
    {{list}}.add(state.ch);
    state.nextChar();
    continue;
  }
  if (state.ch != {{controlChar}}) {
    break;
  }
  final pos = state.pos;
  final ch = state.ch;
  state.nextChar();
  {{p1}}
  if (!state.ok) {
    state.pos = pos;
    state.ch = ch;
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
    final locals = context.allocateLocals(['list', 'test']);
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
