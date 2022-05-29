part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and returns a substring of
/// the parsed data if the criteria was satisfied at least once.
///
/// Example:
/// ```dart
/// TakeWhile1(CharClass('[A-Z] | [a-z] |  "_"'))
/// ```
class TakeWhile1 extends ParserBuilder<Utf16Reader, String> {
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
if (state.ok) {
  {{res0}} = source.substring({{pos}}, state.pos);
} else {
  state.fail({{pos}}, ParseError.character);
}''';

  static const _template16Fast = '''
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
  state.fail({{pos}}, ParseError.character);
}''';

  static const _template32 = '''
final {{pos}} = state.pos;
while (state.pos < source.length) {
  final pos = state.pos;
  final c = source.readRune(state);
  final ok = {{test}};
  if (!ok) {
    state.pos = pos;
    break;
  }
}
state.ok = state.pos != {{pos}};
if (state.ok) {
  {{res0}} = source.substring({{pos}}, state.pos);
} else {
  state.fail({{pos}}, ParseError.character);
}''';

  static const _template32Fast = '''
final {{pos}} = state.pos;
while (state.pos < source.length) {
  final pos = state.pos;
  final c = source.readRune(state);
  final ok = {{test}};
  if (!ok) {
    state.pos = pos;
    break;
  }
}
state.ok = state.pos != {{pos}};
if (!state.ok) {
  state.fail({{pos}}, ParseError.character);
}''';

  final SemanticAction<bool> predicate;

  const TakeWhile1(this.predicate);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    ParseRuntime.addClassUtf16Reader(context);
    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    final isUnicode = predicate.isUnicode;
    values.addAll({
      'test': predicate.build(context, 'test', ['c']),
    });
    final String template;
    if (isUnicode) {
      if (fast) {
        template = _template32Fast;
      } else {
        template = _template32;
      }
    } else {
      if (fast) {
        template = _template16Fast;
      } else {
        template = _template16;
      }
    }

    return render(template, values, [result]);
  }
}
