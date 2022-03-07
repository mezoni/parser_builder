part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria, and returns true.
///
/// Example:
/// ```dart
/// SkipWhile(CharClass('#x9 | #xA | #xD | #x20'))
/// ```
class SkipWhile extends StringParserBuilder<bool> {
  static const _template16 = '''
state.ok = true;
{{transform}}
while (state.pos < source.length) {
  final c = source.codeUnitAt(state.pos);
  final ok = {{cond}};
  if (!ok) {
    break;
  }
  state.pos++;
}
if (state.ok) {
  {{res}} = true;
}''';

  static const _template32 = '''
state.ok = true;
{{transform}}
while (state.pos < source.length) {
  final pos = state.pos;
  var c = source.codeUnitAt(state.pos++);
  if (c > 0xd7ff) {
    c = source.decodeW2(state, c);
  }
  final ok = {{cond}};
  if (!ok) {
    state.pos = pos;
    break;
  }
}
if (state.ok) {
  {{res}} = true;
}''';

  final Transformer<int, bool> predicate;

  const SkipWhile(this.predicate);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['cond']);
    final cond = locals['cond']!;
    return {
      ...locals,
      'cond': predicate.invoke(context, cond, 'c'),
      'transform': predicate.declare(context, cond),
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
