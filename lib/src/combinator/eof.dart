part of '../../combinator.dart';

class Eof<I> extends ParserBuilder<I, void> {
  static const _template = '''
state.ok = state.pos >= source.length;
if (!state.ok) {
  state.error = ParseError.expected(state.pos, 'EOF');
}''';

  const Eof();

  @override
  String build(Context context, ParserResult? result) {
    context.refersToStateSource = true;
    return render(_template, {});
  }
}
