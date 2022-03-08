part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and returns a substring of
/// the parsed data if the criteria was satisfied at least once.
///
/// Example:
/// ```dart
/// TakeWhile1(CharClass('[A-Z] | [a-z] |  "_"'))
/// ```
class TakeWhile1 extends StringParserBuilder<String> {
  static const _template16 = '''
state.ok = false;
final {{pos}} = state.pos;
var {{c}} = 0;
{{transform}}
while (state.pos < source.length) {
  {{c}} = source.codeUnitAt(state.pos);
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
  if (state.pos < source.length) {
    {{c}} = source.decodeW2(state.pos, {{c}});
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
  final pos = state.pos;
  {{c}} = source.readRune(state);
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
  state.error = state.pos < source.length ? ErrUnexpected.char(state.pos, Char({{c}})) : ErrUnexpected.eof(state.pos);
}''';

  final Transformer<bool> predicate;

  const TakeWhile1(this.predicate);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['c', 'cond', 'pos']);
    final c = locals['c']!;
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
    final has32BitChars = predicate is CharPredicate
        ? (predicate as CharPredicate).has32BitChars
        : true;
    return has32BitChars ? _template32 : _template16;
  }
}
