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
  if (!{{test}}(c)) {
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
  c = c & 0xfc00 != 0xd800 ? c : source.runeAt(state.pos);
  if (!{{test}}(c)) {
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
    final locals = context.allocateLocals(['test']);
    return {
      'transform': predicate.transform(locals['test']!),
    }..addAll(locals);
  }

  @override
  String getTemplate(Context context) {
    final has32BitChars = predicate is CharPredicate
        ? (predicate as CharPredicate).has32BitChars
        : true;
    return has32BitChars ? _template32 : _template16;
  }
}
