part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and returns a substring of
/// the parsed data if the criteria was satisfied at least once.
///
/// Example:
/// ```dart
/// TakeWhile1(CharClass('[A-Z] | [a-z] |  "_"'))
/// ```
class TakeWhile1 extends ParserBuilder<String, String> {
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
  if ({{pos}} < source.length) {
    final c = source.runeAt({{pos}});
    state.fail({{pos}}, ParseError.unexpected(0, c));
  } else {
    state.fail({{pos}}, const ParseError.unexpected(0, 'EOF'));
  }
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
  if ({{pos}} < source.length) {
    final c = source.runeAt({{pos}});
    state.fail({{pos}}, ParseError.unexpected(0, c));
  } else {
    state.fail({{pos}}, const ParseError.unexpected(0, 'EOF'));
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
if (state.ok) {
  {{res0}} = source.substring({{pos}}, state.pos);
} else {
  if ({{pos}} < source.length) {
    state.fail({{pos}}, ParseError.unexpected(0, {{c}}!));
  } else {
    state.fail({{pos}}, const ParseError.unexpected(0, 'EOF'));
  }
}''';

  static const _template32Fast = '''
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
    state.fail({{pos}}, ParseError.unexpected(0, {{c}}!));
  } else {
    state.fail({{pos}}, const ParseError.unexpected(0, 'EOF'));
  }
}''';

  final SemanticAction<bool> predicate;

  const TakeWhile1(this.predicate);

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    final fast = result == null;
    final values = context.allocateLocals(['c', 'pos']);
    final isUnicode = predicate.isUnicode;
    final c = isUnicode ? values['c']! : 'c';
    values.addAll({
      'test': predicate.build(context, 'test', [c]),
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
