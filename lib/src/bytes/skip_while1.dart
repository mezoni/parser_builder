part of '../../bytes.dart';

/// Parses while [predicate] satisfies the criteria, and returns true if the
/// criteria was satisfied at least once.
///
/// Example:
/// ```dart
/// SkipWhile1(CharClass('[#x30-#x39]'), unicode: false)
/// ```
class SkipWhile1 extends ParserBuilder<String, bool> {
  static const _template = '''
{{transform}}
while (state.ch != State.eof && {{test}}(state.ch)) {
  state.nextChar();
  {{res}} = true;
}
if ({{res}} != null) {
  state.ok = true;
} else {
  state.ok = false;
  state.error = state.ch == State.eof ? ErrUnexpected.eof(state.pos) : ErrUnexpected.char(state.pos, Char(state.ch));
}''';

  final Transformer<int, bool> predicate;

  final bool unicode;

  const SkipWhile1(this.predicate, {this.unicode = true});

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  Map<String, String> getTags(Context context) {
    final locals = context.allocateLocals(['test']);
    return {
      'transform': predicate.transform(locals['test']!),
    }..addAll(locals);
  }
}
