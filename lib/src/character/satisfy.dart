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
{{transform}}
state.ok = state.ch != State.eof && {{test}}(state.ch);
if (state.ok) {
  {{res}} = state.ch;
  state.nextChar();
} else {
  state.error = state.ch == State.eof ? ErrUnexpected.eof(state.pos) : ErrUnexpected.char(state.pos, Char(state.ch));
}''';

  final Transformer<int, bool> predictate;

  const Satisfy(this.predictate);

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['test']);
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
