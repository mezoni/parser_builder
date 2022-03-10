part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and returns a substring of
/// the parsed data.
///
/// Example:
/// ```dart
/// TakeWhile(CharClass('[#x21-#x7e]'))
/// ```
class TakeWhile extends StringParserBuilder<String> {
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
state.ok = true;
if (state.ok) {
  {{res}} = {{pos}} == state.pos ? '' : source.substring({{pos}}, state.pos);
}''';

  static const _template32 = '''
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
state.ok = true;
if (state.ok) {
  {{res}} = {{pos}} == state.pos ? '' : source.substring({{pos}}, state.pos);
}''';

  final Transformer<bool> predicate;

  const TakeWhile(this.predicate);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['cond', 'pos']);
    final cond = locals['cond']!;
    final t = Transformation(context: context, name: cond, arguments: ['c']);
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
