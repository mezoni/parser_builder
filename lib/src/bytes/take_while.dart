part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and returns a substring of
/// the parsed data.
///
/// Example:
/// ```dart
/// TakeWhile(CharClass('[#x21-#x7e]'))
/// ```
class TakeWhile extends ParserBuilder<Utf16Reader, String> {
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
state.ok = true;
if (state.ok) {
  {{res0}} = {{pos}} == state.pos ? '' : source.substring({{pos}}, state.pos);
}''';

  static const _template16Fast = '''
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
state.ok = true;
if (state.ok) {
  {{res0}} = {{pos}} == state.pos ? '' : source.substring({{pos}}, state.pos);
}''';

  static const _template32Fast = '''
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

  const TakeWhile(this.predicate);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    ParseRuntime.addClassUtf16Reader(context);
    final fast = result == null;
    final values = context.allocateLocals(['pos']);
    values.addAll({
      'test': predicate.build(context, 'test', ['c']),
    });
    final isUnicode = predicate.isUnicode;
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
