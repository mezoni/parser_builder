part of '../../combinator.dart';

class Opt<I, O> extends ParserBuilder<I, O?> {
  final ParserBuilder<I, O> parser;

  const Opt(this.parser);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    Silent<I, O?>(Alt2(parser, Value(null)))
        .build(context, code, result, silent);
  }
}
