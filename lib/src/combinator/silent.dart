part of '../../combinator.dart';

class Silent<I, O> extends ParserBuilder<I, O> {
  final ParserBuilder<I, O> parser;

  const Silent(this.parser);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    return parser.build(context, code, result, true);
  }

  @override
  bool isAlwaysSuccess() {
    return parser.isAlwaysSuccess();
  }
}
