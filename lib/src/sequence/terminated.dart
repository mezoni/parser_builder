part of '../../sequence.dart';

class Terminated<I, O> extends _Sequence<I, O> {
  final ParserBuilder<I, O> parser;

  final ParserBuilder<I, dynamic> terminate;

  const Terminated(this.parser, this.terminate);

  @override
  List<ParserBuilder<I, dynamic>> _getParsers() {
    return [
      parser,
      terminate,
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
    code.setResult(result, r1.name, false);
  }
}
