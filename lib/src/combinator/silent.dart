part of '../../combinator.dart';

class Silent<I, O> extends ParserBuilder<I, O> {
  final ParserBuilder<I, O> parser;

  const Silent(this.parser);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    parser.build(context, code, result, true);
  }
}
