part of '../../sequence.dart';

class SeparatedPair<I, O1, O2> extends _Sequence<I, tuple.Tuple2<O1, O2>> {
  final ParserBuilder<I, O1> first;

  final ParserBuilder<I, dynamic> separator;

  final ParserBuilder<I, O2> second;

  const SeparatedPair(this.first, this.separator, this.second);

  @override
  List<ParserBuilder<I, dynamic>> _getParsers() {
    return [
      first,
      separator,
      second,
    ];
  }

  @override
  bool _isVoidResult(int index) {
    return index == 1;
  }

  @override
  void _setResults(Context context, CodeGen code, ParserResult result,
      List<ParserResult> results) {
    final r1 = results[0];
    final r3 = results[2];
    code.setResult(result, 'Tuple2(${r1.value}, ${r3.value})');
  }
}
