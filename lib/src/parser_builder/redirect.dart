part of '../../parser_builder.dart';

abstract class Redirect<I, O> extends ParserBuilder<I, O> {
  const Redirect();

  @override
  void build(Context context, CodeGen code) {
    final parser = getRedirectParser();
    parser.build(context, code);
  }

  ParserBuilder<I, O> getRedirectParser();
}
