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
class StringValue extends ParserBuilder<String, String> {
  static const _template = '''
state.ok = true;
final {{pos}} = state.pos;
final {{list}} = <String>[];
var {{str}} = '';
while (state.pos < source.length) {
  final {{start}} = state.pos;
  var {{c}} = 0;
  while (state.pos < source.length) {
    final pos = state.pos;
    {{c}} = source.readRune(state);
    final ok = {{test}};
    if (!ok) {
      state.pos = pos;
      break;
    }
  }
  {{str}} = state.pos == {{start}} ? '' : source.substring({{start}}, state.pos);
  if ({{str}} != '' && {{list}}.isNotEmpty) {
    {{list}}.add({{str}});
  }
  if ({{c}} != {{controlChar}}) {
    break;
  }
  state.pos += {{size}};
  {{var1}}
  {{p1}}
  if (!state.ok) {
    state.pos = {{pos}};
    break;
  }
  if ({{list}}.isEmpty && {{str}} != '') {
    {{list}}.add({{str}});
  }
  {{list}}.add(String.fromCharCode({{val1}}));
}
if (state.ok) {
  if ({{list}}.isEmpty) {
    {{res0}} = {{str}};
  } else {
    {{res0}} = {{list}}.join();
  }
}''';

  static const _templateFast = '''
state.ok = true;
final {{pos}} = state.pos;
final {{list}} = <String>[];
var {{str}} = '';
while (state.pos < source.length) {
  final {{start}} = state.pos;
  var {{c}} = 0;
  while (state.pos < source.length) {
    final pos = state.pos;
    {{c}} = source.readRune(state);
    final ok = {{test}};
    if (!ok) {
      state.pos = pos;
      break;
    }
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
  {{list}}.add('');
}''';

  final int controlChar;

  final ParserBuilder<String, int> escape;

  final SemanticAction<bool> normalChar;

  const StringValue(this.normalChar, this.controlChar, this.escape);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    final fast = result == null;
    final values = context.allocateLocals(['c', 'list', 'pos', 'start', 'str']);
    final size = controlChar > 0xffff ? 2 : 1;
    final r1 = context.getResult(escape, !fast);
    values.addAll({
      'controlChar': '$controlChar',
      'p1': escape.build(context, r1),
      'size': '$size',
      'test': normalChar.build(context, 'test', [values['c']!]),
    });
    return render2(fast, _templateFast, _template, values, [result, r1]);
  }
}
