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
  {{res}} = source.substring({{pos}}, state.pos);
} else if (state.log) {
  state.error = ErrUnexpected.charOrEof(state.pos, source);
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
  if (ok) {
    continue;
  }
  state.pos = pos;
  break;
}
state.ok = state.pos != {{pos}};
if (state.ok) {
  {{res}} = source.substring({{pos}}, state.pos);
} else if (state.log) {
  state.error = ErrUnexpected.charOrEof(state.pos, source, {{c}});
}''';

  final Transformer<bool> predicate;

  const TakeWhile1(this.predicate);

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
