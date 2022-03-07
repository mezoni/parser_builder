part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and returns a substring of
/// the parsed data if the criteria were satisfied [m] to [n] times.
///
/// Example:
/// ```dart
/// TakeWhileMN(4, 4, CharClass('[0-9] | [a-f] | [A-F]'))
/// ```
class TakeWhileMN extends StringParserBuilder<String> {
  static const _template16 = '''
final {{pos}} = state.pos;
var {{c}} = 0;
var {{cnt}} = 0;
{{transform}}
while ({{cnt}} < {{n}} && state.pos < source.length) {
  {{c}} = source.codeUnitAt(state.pos);
  final ok = {{cond}};
  if (!ok) {
    break;
  }
  state.pos++;
  {{cnt}}++;
}
state.ok = {{cnt}} >= {{m}};
if (state.ok) {
  {{res}} = {{pos}} == state.pos ? '' : source.substring({{pos}}, state.pos);
} else {
  if (!state.opt) {
    if (state.pos < source.length) {
      if ({{c}} > 0xd7ff) {
        {{c}} = source.runeAt(state.pos);
      }
      state.error = ErrUnexpected.char(state.pos, Char({{c}}));
    } else {
      state.error = ErrUnexpected.eof(state.pos);
    }
  }
  state.pos = {{pos}};
}''';

  static const _template32 = '''
final {{pos}} = state.pos;
var {{c}} = 0;
var {{cnt}} = 0;
{{transform}}
while ({{cnt}} < {{n}} && state.pos < source.length) {
  final pos = state.pos;
  {{c}} = source.codeUnitAt(state.pos++);
  if ({{c}} > 0xd7ff) {
    {{c}} = source.decodeW2(state, {{c}});
  }
  final ok = {{cond}};
  if (!ok) {
    state.pos = pos;
    break;
  }
  {{cnt}}++;
}
state.ok = {{cnt}} >= {{m}};
if (state.ok) {
  {{res}} = {{pos}} == state.pos ? '' : source.substring({{pos}}, state.pos);
} else {
  if (!state.opt) {
    state.error = state.pos < source.length ? ErrUnexpected.char(state.pos, Char({{c}})) : ErrUnexpected.eof(state.pos);
  }
  state.pos = {{pos}};
}''';

  final Transformer<int, bool> predicate;

  final int m;

  final int n;

  const TakeWhileMN(this.m, this.n, this.predicate);

  @override
  Map<String, String> getTags(Context context) {
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

    final locals = context.allocateLocals(['c', 'cnt', 'cond', 'pos']);
    final c = locals['c']!;
    final cond = locals['cond']!;
    return {
      ...locals,
      'm': m.toString(),
      'n': n.toString(),
      'cond': predicate.invoke(context, cond, c),
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
