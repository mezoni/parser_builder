part of '../../character.dart';

abstract class _Chars0 extends StringParserBuilder<String> {
  static const _template = '''
final {{pos}} = state.pos;
{{transform}}
while (state.pos < source.length) {
  var c = source.codeUnitAt(state.pos);
  c = c <= 0xD7FF || c >= 0xE000 ? c : source.runeAt(state.pos);
  if (!{{test}}(c)) {
    break;
  }
  state.pos += c > 0xffff ? 2 : 1;
}
state.ok = true;
if (state.ok) {
  {{res}} = source.substring({{pos}}, state.pos);
}''';

  const _Chars0();

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['pos', 'test']);
    final predicate = _getCharacterPredicate();
    return {
      'transform': predicate.transform(locals['test']!),
    }..addAll(locals);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([_getCharacterPredicate()]);
  }

  Transformer<int, bool> _getCharacterPredicate();
}

abstract class _Chars1 extends StringParserBuilder<String> {
  static const _template = '''
state.ok = false;
final {{pos}} = state.pos;
var {{c}} = 0;
{{transform}}
while (state.pos < source.length) {
  {{c}} = source.codeUnitAt(state.pos);
  {{c}} = {{c}} <= 0xD7FF || {{c}} >= 0xE000 ? {{c}} : source.runeAt(state.pos);
  if (!{{test}}({{c}})) {
    break;
  }
  state.pos += {{c}} > 0xffff ? 2 : 1;
  state.ok = true;
}
if (state.ok) {
  {{res}} = source.substring({{pos}}, state.pos);
} else  {
  state.error = state.pos < source.length ? ErrUnexpected.char(state.pos, Char({{c}})) : ErrUnexpected.eof(state.pos);
}''';

  const _Chars1();

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['pos', 'c', 'test']);
    final predicate = _getCharacterPredicate();
    return {
      'transform': predicate.transform(locals['test']!),
    }..addAll(locals);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([_getCharacterPredicate()]);
  }

  Transformer<int, bool> _getCharacterPredicate();
}
