part of '../../character.dart';

abstract class _Chars0 extends ParserBuilder<String, String> {
  static const _template = '''
final {{pos}} = state.pos;
var {{c}} = state.ch;
{{transform}}
while ({{c}} != State.eof && {{test}}({{c}})) {
  {{c}} = state.nextChar();
}
state.ok = true;
if (state.ok) {
  {{res}} = state.source.substring({{pos}}, state.pos);
}''';

  const _Chars0();

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

abstract class _Chars1 extends ParserBuilder<String, String> {
  static const _template = '''
state.ok = false;
final {{pos}} = state.pos;
var {{c}} = state.ch;
{{transform}}
while ({{c}} != State.eof && {{test}}({{c}})) {
  {{c}} = state.nextChar();
  state.ok = true;
}
if (state.ok) {
  {{res}} = state.source.substring({{pos}}, state.pos);
} else  {
  state.error = {{c}} == State.eof ? ErrUnexpected.eof({{pos}}) : ErrUnexpected.char({{pos}}, Char({{c}}));
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
