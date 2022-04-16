part of '../../sequence.dart';

class Preceded<I, O> extends _Sequence<I, O> {
  final ParserBuilder<I, dynamic> precede;

  final ParserBuilder<I, O> parser;

  const Preceded(this.precede, this.parser);

  @override
  List<ParserBuilder<I, dynamic>> _getParsers() {
    return [
      precede,
      parser,
    ];
  }

  @override
  bool _isVoidResult(int index) {
    return index == 0;
  }

  @override
  void _setResult(Context context, CodeGen code, List<ParserResult> results) {
    final result1 = results[1];
    code.setResult(result1.name, false);
  }
}
