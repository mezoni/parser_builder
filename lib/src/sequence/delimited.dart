part of '../../sequence.dart';

class Delimited<I, O> extends _Sequence<I, O> {
  final ParserBuilder<I, dynamic> after;

  final ParserBuilder<I, dynamic> before;

  final ParserBuilder<I, O> parser;

  const Delimited(this.before, this.parser, this.after);

  @override
  List<ParserBuilder<I, dynamic>> _getParsers() {
    return [
      before,
      parser,
      after,
    ];
  }

  @override
  bool _isVoidResult(int index) {
    return index == 0 || index == 2;
  }

  @override
  void _setResults(Context context, CodeGen code, ParserResult result,
      List<ParserResult> results) {
    final r2 = results[1];
    code.setResult(result, r2.name, false);
  }
}
