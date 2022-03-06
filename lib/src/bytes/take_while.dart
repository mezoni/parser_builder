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
state.ok = true;
final {{pos}} = state.pos;
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
  {{res}} = {{pos}} == state.pos ? '' : source.substring({{pos}}, state.pos);
}''';

  static const _template32 = '''
final {{pos}} = state.pos;
{{transform}}
while (state.pos < source.length) {
  var size = 1;
  var c = source.codeUnitAt(state.pos);
  if (c > 0xd7ff) {
    c = source.runeAt(state.pos);
    size = c > 0xffff ? 2 : 1;
  }
  final ok = {{cond}};
  if (!ok) {
    break;
  }
  state.pos += size;
}
state.ok = true;
if (state.ok) {
  {{res}} = {{pos}} == state.pos ? '' : source.substring({{pos}}, state.pos);
}''';

  final Transformer<int, bool> predicate;

  const TakeWhile(this.predicate);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['cond', 'pos']);
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
