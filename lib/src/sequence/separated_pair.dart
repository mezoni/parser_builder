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
  void _setResult(Context context, CodeGen code, List<ParserResult> results) {
    final result1 = results[0];
    final result2 = results[2];
    code.setResult('Tuple2(${result1.value}, ${result2.value})');
  }
}
