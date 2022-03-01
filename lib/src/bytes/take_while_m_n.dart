part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria and returns a substring of
/// the parsed data if the criteria were satisfied [m] to [n] times.
///
/// Example:
/// ```dart
/// TakeWhileMN(4, 4, CharClass('[0-9] | [a-f] | [A-F]'))
/// ```
class TakeWhileMN extends ParserBuilder<String, String> {
  static const _template = '''
final {{pos}} = state.pos;
final {{ch}} = state.ch;
var {{c}} = {{ch}};
var {{cnt}} = 0;
{{transform}}
while ({{cnt}} < {{n}}) {
  if ({{c}} == State.eof || !{{test}}({{c}})) {
    break;
  }
  {{c}} = state.nextChar();
  {{cnt}}++;
}
state.ok = {{cnt}} >= {{m}};
if (state.ok) {
  {{res}} = state.source.substring({{pos}}, state.pos);
} else {
  state.error = {{c}} == State.eof ? ErrUnexpected.eof(state.pos) : ErrUnexpected.char(state.pos, Char({{c}}));
  state.pos = {{pos}};
  state.ch = {{ch}};
}''';

  final Transformer<int, bool> predicate;

  final int m;

  final int n;

  const TakeWhileMN(this.m, this.n, this.predicate);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['pos', 'ch', 'c', 'cnt', 'test']);
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
