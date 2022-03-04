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
  if (!{{test}}({{c}})) {
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
      {{c}} = {{c}} & 0xfc00 != 0xd800 ? {{c}} : source.runeAt(state.pos);
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
  {{c}} = source.codeUnitAt(state.pos);
  {{c}} = {{c}} & 0xfc00 != 0xd800 ? {{c}} : source.runeAt(state.pos);
  if (!{{test}}({{c}})) {
    break;
  }
  state.pos += {{c}} > 0xffff ? 2 : 1;
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

    final locals = context.allocateLocals(['c', 'cnt', 'pos', 'test']);
    return {
      'm': m.toString(),
      'n': n.toString(),
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
