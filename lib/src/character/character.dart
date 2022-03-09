part of '../../character.dart';

abstract class _Chars0 extends StringParserBuilder<String> {
  static const _template16 = '''
state.ok = true;
final {{pos}} = state.pos;
{{transform}}
while (state.pos < source.length) {
  final c = source.codeUnitAt(state.pos);
  final ok = {{cond}};
  if (ok) {
    state.pos++;
    continue;
  }
  break;
}
if (state.ok) {
  {{res}} = source.substring({{pos}}, state.pos);
}''';

  static const _template32 = '''
state.ok = true;
final {{pos}} = state.pos;
{{transform}}
while (state.pos < source.length) {
  final pos = state.pos;
  var c = source.readRune(state);
  final ok = {{cond}};
  if (ok) {
    continue;
  }
  state.pos = pos;
  break;
}
if (state.ok) {
  {{res}} = source.substring({{pos}}, state.pos);
}''';

  const _Chars0();

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['cond', 'pos']);
    final cond = locals['cond']!;
    final predicate = _getCharacterPredicate();
    final t = Transformation(context: context, name: cond, arguments: ['c']);
    return {
      ...locals,
      'transform': predicate.declare(t),
      'cond': predicate.invoke(t),
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

  Transformer<bool> _getCharacterPredicate();
}

abstract class _Chars1 extends StringParserBuilder<String> {
  static const _template16 = '''
state.ok = false;
final {{pos}} = state.pos;
{{transform}}
while (state.pos < source.length) {
  final c = source.codeUnitAt(state.pos);
  final ok = {{cond}};
  if (!ok) {
    break;
  }
  state.pos++;
  state.ok = true;
}
if (state.ok) {
  {{res}} = source.substring({{pos}}, state.pos);
} else if (!state.opt) {
  state.error = state.pos < source.length ? ErrUnexpected.char(state.pos, Char(source.runeAt(state.pos))) : ErrUnexpected.eof(state.pos);
}''';

  static const _template32 = '''
state.ok = false;
final {{pos}} = state.pos;
var {{c}} = 0;
{{transform}}
while (state.pos < source.length) {
  final pos = state.pos;
  var c = source.readRune(state);
  final ok = {{cond}};
  if (!ok) {
    state.pos = pos;
    break;
  }
  state.ok = true;
}
if (state.ok) {
  {{res}} = source.substring({{pos}}, state.pos);
} else if (!state.opt) {
  state.error = state.pos < source.length ? ErrUnexpected.char(state.pos, Char(state.pos)) : ErrUnexpected.eof(state.pos);
}''';

  const _Chars1();

  @override
  Map<String, String> getTags(Context context) {
    final predicate = _getCharacterPredicate();
    final has32BitChars = predicate is CharPredicate
        ? (predicate as CharPredicate).has32BitChars
        : true;
    final locals =
        context.allocateLocals([if (has32BitChars) 'c', 'cond', 'pos']);
    final c = has32BitChars ? locals['c']! : 'c';
    final cond = locals['cond']!;
    final t = Transformation(context: context, name: cond, arguments: [c]);
    return {
      ...locals,
      'transform': predicate.declare(t),
      'cond': predicate.invoke(t),
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

  Transformer<bool> _getCharacterPredicate();
}
