part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria, and returns true.
///
/// Example:
/// ```dart
/// SkipWhile(CharClass('#x9 | #xA | #xD | #x20'))
/// ```
class SkipWhile extends ParserBuilder<Utf16Reader, void> {
  static const _template16 = '''
while (state.pos < source.length) {
  final c = source.codeUnitAt(state.pos);
  final ok = {{test}};
  if (!ok) {
    break;
  }
  state.pos++;
}
state.ok = true;''';

  static const _template32 = '''
while (state.pos < source.length) {
  final pos = state.pos;
  final c = source.readRune(state);
  final ok = {{test}};
  if (!ok) {
    state.pos = pos;
    break;
  }
}
state.ok = true;''';

  final SemanticAction<bool> predicate;

  const SkipWhile(this.predicate);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    ParseRuntime.addClassUtf16Reader(context);
    final isUnicode = predicate.isUnicode;
    final values = {
      'test': predicate.build(context, 'test', ['c']),
    };
    return render2(isUnicode, _template32, _template16, values);
  }
}
