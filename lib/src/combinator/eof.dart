part of '../../combinator.dart';

class Eof<I> extends ParserBuilder<I, bool> {
  static const _template = '''
state.ok = state.pos >= state.source.length;
if (state.ok) {
  {{res}} = true;
} else if (state.log) {
  state.error = ErrExpected.eof(state.pos);
}''';

  const Eof();

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName(const []);
  }
}
