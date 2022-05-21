part of '../../error.dart';

@experimental
class WithStartAndLastErrorPos<I, O> extends ParserBuilder<I, O> {
  final ParserBuilder<I, O> parser;

  const WithStartAndLastErrorPos(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    return WithStart(WithLastErrorPos(parser)).build(context, result);
  }
}
