part of '../../character.dart';

/// Parses a single character, and if [predicate] satisfies the criteria,
/// returns that character.
///
/// Example:
/// ```dart
/// Satisfy(isSomeChar)
/// ```
class Satisfy extends ParserBuilder<String, int> {
  static const _template = '''
final {{c}} = state.ch;
{{transform}}
state.ok = {{c}} != State.eof && {{test}}({{c}});
if (state.ok) {
  {{res}} = {{c}};
  state.nextChar();
} else {
  state.error = {{c}} == State.eof ? ErrUnexpected.eof(state.pos) : ErrUnexpected.char(state.pos, Char({{c}}));
}''';

  final Transformer<int, bool> predictate;

  const Satisfy(this.predictate);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['c', 'test']);
    return {
      'transform': predictate.transform(locals['test']!),
    }..addAll(locals);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([predictate]);
  }
}
