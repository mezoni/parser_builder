part of '../../combinator.dart';

class Fast<I> extends ParserBuilder<I, void> {
  final ParserBuilder<I, dynamic> parser;

  const Fast(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    return parser.build(context, null);
  }
}
