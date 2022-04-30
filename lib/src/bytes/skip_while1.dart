part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria, and returns true if the
/// criteria was satisfied at least once.
///
/// Example:
/// ```dart
/// SkipWhile1(CharClass('[#x30-#x39]'), unicode: false)
/// ```
class SkipWhile1 extends ParserBuilder<String, void> {
  static const _template16 = '''
final {{pos}} = state.pos;
while (state.pos < source.length) {
  final c = source.codeUnitAt(state.pos);
  final ok = {{test}};
  if (!ok) {
    break;
  }
  state.pos++;
}
state.ok = state.pos != {{pos}};
if (!state.ok) {
  if ({{pos}} < source.length) {
    final c = source.runeAt({{pos}});
    state.error = ParseError.unexpected({{pos}}, 0, c);
  } else {
    state.error = ParseError.unexpected({{pos}}, 0, 'EOF');
  }
}''';

  static const _template32 = '''
final {{pos}} = state.pos;
int? {{c}};
while (state.pos < source.length) {
  final pos = state.pos;
  {{c}} = source.readRune(state);
  final ok = {{test}};
  if (!ok) {
    state.pos = pos;
    break;
  }
}
state.ok = state.pos != {{pos}};
if (!state.ok) {
  if ({{pos}} < source.length) {
    state.error = ParseError.unexpected({{pos}}, 0, {{c}}!);
  } else {
    state.error = ParseError.unexpected({{pos}}, 0, 'EOF');
  }
}''';

  final SemanticAction<bool> predicate;

  const SkipWhile1(this.predicate);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    final values = context.allocateLocals(['c', 'pos']);
    final isUnicode = predicate.isUnicode;
    final c = isUnicode ? values['c']! : 'c';
    values.addAll({
      'test': predicate.build(context, 'test', [c]),
    });
    return render2(isUnicode, _template32, _template16, values);
  }
}
