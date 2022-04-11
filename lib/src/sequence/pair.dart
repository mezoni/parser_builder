part of '../../sequence.dart';

class Pair<I, O1, O2> extends _Sequence<I, tuple.Tuple2<O1, O2>> {
  final ParserBuilder<I, O1> first;

  final ParserBuilder<I, O2> second;

  const Pair(this.first, this.second);

  @override
  List<ParserBuilder<I, dynamic>> _getParsers() {
    return [
      first,
      second,
    ];
  }

  @override
  void _setResults(Context context, CodeGen code, ParserResult result,
      List<ParserResult> results) {
    final r1 = results[0];
    final r2 = results[1];
    code.setResult(result, 'Tuple2(${r1.value}, ${r2.value})');
  }
}
