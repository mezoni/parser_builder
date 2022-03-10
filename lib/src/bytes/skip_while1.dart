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
state.ok = state.pos != {{pos}};
if (state.ok) {
  {{res}} = true;
} else if (state.log) {
  state.error = state.pos < source.length ? ErrUnexpected.char(state.pos, Char(source.runeAt(state.pos))) : ErrUnexpected.eof(state.pos);
}''';

  static const _template32 = '''
final {{pos}} = state.pos;
var {{c}} = 0;
{{transform}}
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
state.ok = state.pos != {{pos}};
if (state.ok) {
  {{res}} = true;
} else if (state.log) {
  state.error = state.pos < source.length ? ErrUnexpected.char(state.pos, Char({{c}})) : ErrUnexpected.eof(state.pos);
}''';

  final Transformer<bool> predicate;

  const SkipWhile1(this.predicate);

  @override
  Map<String, String> getTags(Context context) {
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
    final has32BitChars = predicate is CharPredicate
        ? (predicate as CharPredicate).has32BitChars
        : true;
    return has32BitChars ? _template32 : _template16;
  }
}
