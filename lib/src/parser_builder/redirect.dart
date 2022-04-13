part of '../../parser_builder.dart';

abstract class Redirect<I, O> extends ParserBuilder<I, O> {
  const Redirect();

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final parser = getRedirectParser();
    return parser.build(context, code, result, silent);
  }

  ParserBuilder<I, O> getRedirectParser();

  @override
  bool isAlwaysSuccess() {
    final parser = getRedirectParser();
    return parser.isAlwaysSuccess();
  }
}
