part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and returns a substring of
/// the parsed data if the criteria were satisfied [m] to [n] times.
///
/// Example:
/// ```dart
/// TakeWhileMN(4, 4, CharClass('[0-9] | [a-f] | [A-F]'))
/// ```
class TakeWhileMN extends ParserBuilder<String, String> {
  static const _template16 = '''
final {{pos}} = state.pos;
var {{count}} = 0;
while ({{count}} < {{n}} && state.pos < source.length) {
  final c = source.codeUnitAt(state.pos);
  final ok = {{test}};
  if (!ok) {
    break;
  }
  state.pos++;
  {{count}}++;
}
state.ok = {{count}} >= {{m}};
if (state.ok) {
  {{res0}} = source.substring({{pos}}, state.pos);
} else {
  state.fail(state.pos, ParseError.character);
  state.pos = {{pos}};
}''';

  static const _template16Fast = '''
final {{pos}} = state.pos;
var {{count}} = 0;
while ({{count}} < {{n}} && state.pos < source.length) {
  final c = source.codeUnitAt(state.pos);
  final ok = {{test}};
  if (!ok) {
    break;
  }
  state.pos++;
  {{count}}++;
}
state.ok = {{count}} >= {{m}};
if (!state.ok) {
  state.fail(state.pos, ParseError.character);
  state.pos = {{pos}};
}''';

  static const _template32 = '''
final {{pos}} = state.pos;
var {{count}} = 0;
while ({{count}} < {{n}} && state.pos < source.length) {
  final pos = state.pos;
  final c = source.readRune(state);
  final ok = {{test}};
  if (!ok) {
    state.pos = pos;
    break;
  }
  {{count}}++;
}
state.ok = {{count}} >= {{m}};
if (state.ok) {
  {{res0}} = source.substring({{pos}}, state.pos);
} else {
  state.fail(state.pos, ParseError.character);
  state.pos = {{pos}};
}''';

  static const _template32Fast = '''
final {{pos}} = state.pos;
var {{count}} = 0;
while ({{count}} < {{n}} && state.pos < source.length) {
  final pos = state.pos;
  final c = source.readRune(state);
  final ok = {{test}};
  if (!ok) {
    state.pos = pos;
    break;
  }
  {{count}}++;
}
state.ok = {{count}} >= {{m}};
if (!state.ok) {
  state.fail(state.pos, ParseError.character);
  state.pos = {{pos}};
}''';

  final int m;

  final int n;

  final SemanticAction<bool> predicate;

  const TakeWhileMN(this.m, this.n, this.predicate);

  @override
  String build(Context context, ParserResult? result) {
    if (m < 0) {
      throw RangeError.value(m, 'm', 'Must be equal to or greater than 0');
    }

    if (n < m) {
      throw RangeError.value(
          n, 'n', 'Must be equal to or greater than \'m\' ($m)');
    }

    if (n == 0) {
      throw RangeError.value(n, 'n', 'Must be greater than 0');
    }

    context.refersToStateSource = true;
    final fast = result == null;
    final values = context.allocateLocals(['count', 'pos']);
    final isUnicode = predicate.isUnicode;
    values.addAll({
      'm': '$m',
      'n': '$n',
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
