part of '../../sequence.dart';

abstract class _Sequence<I, O> extends ParserBuilder<I, O> {
  const _Sequence();

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final parsers = _getParsers();
    if (parsers.length < 2) {
      throw StateError('The list of parsers must contain at least 2 elements');
    }

    final fast = result.isVoid;
    final results = <ParserResult>[];
    final pos = context.allocateLocal('pos');
    code + 'final $pos = state.pos;';
    void plunge(int index) {
      final parser = parsers[index];
      final isVoid = _isVoidResult(index) ? true : fast;
      final r1 = helper.build(context, code, parser, silent, isVoid);
      results.add(r1);
      if (index < parsers.length - 1) {
        code.ifChildSuccess(r1, (code) {
          plunge(++index);
        });
      } else {
        code.ifChildSuccess(r1, (code) {
          _setResults(context, code, result, results);
          code.labelSuccess(result);
        }, else_: (code) {
          if (parsers.length == 2) {
            code + 'state.pos = $pos;';
          }
        });
      }
    }

    plunge(0);
    if (parsers.length != 2) {
      code.ifFailure((code) {
        code + 'state.pos = $pos;';
        code.labelFailure(result);
      });
    }
  }

  List<ParserBuilder<I, dynamic>> _getParsers();

  bool _isVoidResult(int index) {
    return false;
  }

  void _setResults(Context context, CodeGen code, ParserResult result,
      List<ParserResult> results);
}
