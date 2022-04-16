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
  void _setResult(Context context, CodeGen code, List<ParserResult> results) {
    final result1 = results[0];
    code.setResult(result1.name, false);
  }
}
