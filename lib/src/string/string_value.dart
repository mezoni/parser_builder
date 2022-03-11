part of '../../string.dart';

/// Parses the value of a string data type using the [normalChar] predicate to
/// parse regular (unescaped) characters, using the [controlChar] character to
/// match an escape character, and the [escape] parser to parse the
/// interpretation of the escape sequence.
///
/// Example:
/// ```dart
/// StringValue(_isNormalChar, 0x5c, _escaped);
/// ```
class StringValue extends StringParserBuilder<String> {
  static const _template = '''
state.ok = true;
final {{pos}} = state.pos;
final {{list}} = [];
var {{str}} = '';
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
  {{str}} = state.pos == {{start}} ? '' : source.substring({{start}}, state.pos);
  if ({{str}} != '' && {{list}}.isNotEmpty) {
    {{list}}.add({{str}});
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
  if ({{list}}.isEmpty && {{str}} != '') {
    {{list}}.add({{str}});
  }
  {{list}}.add({{p1_val}});
}
if (state.ok) {
  if ({{list}}.isEmpty) {
    {{res}} = {{str}};
  } else if ({{list}}.length == 1) {
    final c = {{list}}[0] as int;
    {{res}} = String.fromCharCode(c);
  } else {
    final buffer = StringBuffer();
    for (var i = 0; i < {{list}}.length; i++) {
      final obj = {{list}}[i];
      if (obj is int) {
        buffer.writeCharCode(obj);
      } else {
        buffer.write(obj);
      }
    }
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
        context.allocateLocals(['c', 'cond', 'list', 'pos', 'start', 'str']);
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
