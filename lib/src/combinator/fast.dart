part of '../../combinator.dart';

class Fast<I> extends ParserBuilder<I, void> {
  final ParserBuilder<I, dynamic> parser;

  const Fast(this.parser);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final result1 = helper.getVoidResult(context, code, parser, result);
    return helper.build(context, code, parser, result1, silent);
  }

  @override
  bool isAlwaysSuccess() {
    return parser.isAlwaysSuccess();
  }
}
