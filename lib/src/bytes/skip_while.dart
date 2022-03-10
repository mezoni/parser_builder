part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria, and returns true.
///
/// Example:
/// ```dart
/// SkipWhile(CharClass('#x9 | #xA | #xD | #x20'))
/// ```
class SkipWhile extends StringParserBuilder<bool> {
  static const _template16 = '''
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
  {{res}} = true;
}''';

  static const _template32 = '''
{{transform}}
while (state.pos < source.length) {
  final pos = state.pos;
  final c = source.readRune(state);
  final ok = {{cond}};
  if (ok) {
    continue;
  }
  state.pos = pos;
  break;
}
state.ok = true;
if (state.ok) {
  {{res}} = true;
}''';

  final Transformer<bool> predicate;

  const SkipWhile(this.predicate);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['cond']);
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
