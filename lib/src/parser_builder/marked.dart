part of '../../parser_builder.dart';

@experimental
class Marked<I, O> extends ParserBuilder<I, O> {
  final String name;

  final ParserBuilder<I, O> parser;

  const Marked(this.name, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    return parser.build(context, result);
  }
}
