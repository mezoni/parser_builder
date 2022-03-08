part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria, and returns true if the
/// criteria was satisfied at least once.
///
/// Example:
/// ```dart
/// SkipWhile1(CharClass('[#x30-#x39]'), unicode: false)
/// ```
class SkipWhile1 extends StringParserBuilder<bool> {
  static const _template16 = '''
var {{c}} = 0;
{{transform}}
while (state.pos < source.length) {
  {{c}} = source.codeUnitAt(state.pos);
  final ok = {{cond}};
  if (!ok) {
    break;
  }
  state.pos++;
  {{res}} = true;
}
state.ok = {{res}} != null;
if (!state.ok) {
  if (state.pos < source.length) {
    {{c}} = source.decodeW2(state.pos, {{c}});
    state.error = ErrUnexpected.char(state.pos, Char({{c}}));
  } else {
    state.error = ErrUnexpected.eof(state.pos);
  }
}''';

  static const _template32 = '''
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
  {{res}} = true;
}
state.ok = {{res}} != null;
if (!state.ok) {
  state.error = state.pos < source.length ? ErrUnexpected.char(state.pos, Char({{c}})) : ErrUnexpected.eof(state.pos);
}''';

  final Transformer<bool> predicate;

  const SkipWhile1(this.predicate);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['c', 'cond']);
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
