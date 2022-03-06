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
  var c = source.codeUnitAt(state.pos);
  if (c > 0xd7ff) {
    c = source.runeAt(state.pos);
  }
  final ok = {{cond}};
  if (!ok) {
    break;
  }
  state.pos += c > 0xffff ? 2 : 1;
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
      ...helper.tfToTemplateValues(predicate,
          key: 'cond', name: cond, value: 'c'),
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
