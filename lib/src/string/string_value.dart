part of '../../string.dart';

@experimental
class StringValue extends StringParserBuilder<String> {
  static const _template = '''
state.ok = true;
final {{list}} = [];
final {{pos}} = state.pos;
{{transform}}
while (state.pos < source.length) {
  final {{start}} = state.pos;
  var {{c}} = 0;
  while (state.pos < source.length) {
    final pos = state.pos;
    {{c}} = source.readRune(state);
    final ok = {{cond}};
    if (ok) {
      continue;
    }
    state.pos = pos;
    break;
  }
  if (state.pos != {{start}}) {
    {{list}}.add(source.substring({{start}}, state.pos));
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
  {{list}}.add({{p1_val}});
}
if (state.ok) {
  if ({{list}}.isEmpty) {
    {{res}} = '';
  } else if ({{list}}.length == 1) {
    final obj = {{list}}[0];
    if (obj is int) {
      {{res}} = String.fromCharCode(obj);
    } else {
      {{res}} = obj as String;
    }
  } else {
    final buffer = StringBuffer();
    buffer.writeAll({{list}});
    {{res}} = buffer.toString();
  }
}''';

  final int controlChar;

  final ParserBuilder<String, int> escape;

  final Transformer<bool> normalChar;

  const StringValue(this.normalChar, this.controlChar, this.escape);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': escape,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    final locals =
        context.allocateLocals(['c', 'cond', 'list', 'pos', 'start']);
    final c = locals['c']!;
    final cond = locals['cond']!;
    final t = Transformation(context: context, name: cond, arguments: [c]);
    return {
      'controlChar': controlChar.toString(),
      'size': (controlChar > 0xffff ? 2 : 1).toString(),
      ...locals,
      'cond': normalChar.invoke(t),
      'transform': normalChar.declare(t),
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([normalChar, controlChar, escape]);
  }
}
