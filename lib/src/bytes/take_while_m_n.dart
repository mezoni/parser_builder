part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and returns a substring of
/// the parsed data if the criteria were satisfied [m] to [n] times.
///
/// Example:
/// ```dart
/// TakeWhileMN(4, 4, CharClass('[0-9] | [a-f] | [A-F]'))
/// ```
class TakeWhileMN extends StringParserBuilder<String> {
  static const _template = '''
final {{pos}} = state.pos;
var {{c}} = 0;
var {{cnt}} = 0;
{{transform}}
while ({{cnt}} < {{n}} && state.pos < source.length) {
  {{c}} = source.codeUnitAt(state.pos);
  {{c}} = {{c}} <= 0xD7FF || {{c}} >= 0xE000 ? {{c}} : source.runeAt(state.pos);
  if (!{{test}}({{c}})) {
    break;
  }
  state.pos += {{c}} > 0xffff ? 2 : 1;
  {{cnt}}++;
}
state.ok = {{cnt}} >= {{m}};
if (state.ok) {
  {{res}} = source.substring({{pos}}, state.pos);
} else {
  state.error = state.pos < source.length ? ErrUnexpected.char(state.pos, Char({{c}})) : ErrUnexpected.eof(state.pos);
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

    final locals = context.allocateLocals(['pos', 'c', 'cnt', 'test']);
    return {
      'm': m.toString(),
      'n': n.toString(),
      'transform': predicate.transform(locals['test']!),
    }..addAll(locals);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }
}
