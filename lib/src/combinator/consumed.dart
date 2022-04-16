part of '../../combinator.dart';

class Consumed<I, O> extends Redirect<I, tuple.Tuple2<I, O>> {
  final ParserBuilder<I, O> parser;

  const Consumed(this.parser);

  @override
  ParserBuilder<I, tuple.Tuple2<I, O>> getRedirectParser() {
    final key = Object();
    return Tuple2(Recognize(SetResult<I, O>(key, parser)), GetResult(key));
  }
}
