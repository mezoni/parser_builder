part of '../../character.dart';

abstract class _Chars0 extends StringParserBuilder<String> {
  static const _template16 = '''
state.ok = true;
final {{pos}} = state.pos;
{{transform}}
while (state.pos < source.length) {
  final c = source.codeUnitAt(state.pos);
  if (!{{cond}}) {
    break;
  }
  state.pos++;
}
if (state.ok) {
  {{res}} = {{pos}} == state.pos ? '' : source.substring({{pos}}, state.pos);
}''';

  static const _template32 = '''
state.ok = true;
final {{pos}} = state.pos;
{{transform}}
while (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  c = c & 0xfc00 != 0xd800 ? c : source.runeAt(state.pos);
  if (!{{cond}}) {
    break;
  }
  state.pos += c > 0xffff ? 2 : 1;
}
if (state.ok) {
  {{res}} = {{pos}} == state.pos ? '' : source.substring({{pos}}, state.pos);
}''';

  const _Chars0();

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['cond', 'pos']);
    final cond = locals['cond']!;
    final predicate = _getCharacterPredicate();
    return {
      ...locals,
      ...helper.tfToTemplateValues(predicate,
          key: 'cond', name: cond, value: 'c'),
    };
  }

  @override
  String getTemplate(Context context) {
    final predicate = _getCharacterPredicate();
    final has32BitChars = predicate is CharPredicate
        ? (predicate as CharPredicate).has32BitChars
        : true;
    return has32BitChars ? _template32 : _template16;
  }

  @override
  String toString() {
    return printName([_getCharacterPredicate()]);
  }

  Transformer<int, bool> _getCharacterPredicate();
}

abstract class _Chars1 extends StringParserBuilder<String> {
  static const _template16 = '''
state.ok = false;
final {{pos}} = state.pos;
var {{c}} = 0;
{{transform}}
while (state.pos < source.length) {
  {{c}} = source.codeUnitAt(state.pos);
  if (!{{cond}}) {
    break;
  }
  state.pos++;
  state.ok = true;
}
if (state.ok) {
  {{res}} = source.substring({{pos}}, state.pos);
} else if (!state.opt) {
  if (state.pos < source.length) {
    {{c}} = {{c}} & 0xfc00 != 0xd800 ? {{c}} : source.runeAt(state.pos);
    state.error = ErrUnexpected.char(state.pos, Char({{c}}));
  } else {
    state.error = ErrUnexpected.eof(state.pos);
  }
}''';

  static const _template32 = '''
state.ok = false;
final {{pos}} = state.pos;
var {{c}} = 0;
{{transform}}
while (state.pos < source.length) {
  {{c}} = source.codeUnitAt(state.pos);
  {{c}} = {{c}} & 0xfc00 != 0xd800 ? {{c}} : source.runeAt(state.pos);
  if (!{{cond}}) {
    break;
  }
  state.pos += {{c}} > 0xffff ? 2 : 1;
  state.ok = true;
}
if (state.ok) {
  {{res}} = source.substring({{pos}}, state.pos);
} else if (!state.opt) {
  state.error = state.pos < source.length ? ErrUnexpected.char(state.pos, Char({{c}})) : ErrUnexpected.eof(state.pos);
}''';

  const _Chars1();

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['c', 'cond', 'pos']);
    final c = locals['c']!;
    final cond = locals['cond']!;
    final predicate = _getCharacterPredicate();
    return {
      ...locals,
      ...helper.tfToTemplateValues(predicate,
          key: 'cond', name: cond, value: c),
    };
  }

  @override
  String getTemplate(Context context) {
    final predicate = _getCharacterPredicate();
    final has32BitChars = predicate is CharPredicate
        ? (predicate as CharPredicate).has32BitChars
        : true;
    return has32BitChars ? _template32 : _template16;
  }

  @override
  String toString() {
    return printName([_getCharacterPredicate()]);
  }

  Transformer<int, bool> _getCharacterPredicate();
}
