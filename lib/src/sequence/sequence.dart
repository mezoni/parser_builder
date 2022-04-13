part of '../../sequence.dart';

abstract class _Sequence<I, O> extends ParserBuilder<I, O> {
  const _Sequence();

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final key = BuidlResult();
    final parsers = _getParsers();
    if (parsers.length < 2) {
      throw StateError('The list of parsers must contain at least 2 elements');
    }

    final fast = result.isVoid;
    final results = <ParserResult>[];
    final isHeadAlwaysSuccess = parsers[0].isAlwaysSuccess();
    final isTailAlwaysSuccess =
        parsers.skip(1).where((e) => e.isAlwaysSuccess()).length ==
            parsers.length - 1;
    var failureIndex = -1;
    if (!isHeadAlwaysSuccess && isTailAlwaysSuccess) {
      failureIndex = 0;
    }

    final pos = isTailAlwaysSuccess ? '' : context.allocateLocal('pos');
    code += pos.isEmpty ? '' : 'final $pos = state.pos;';
    void plunge(int index) {
      final parser = parsers[index];
      final isVoid = _isVoidResult(index) ? true : fast;
      final result1 = helper.getResult(context, code, parser, isVoid);
      results.add(result1);
      if (index < parsers.length - 1) {
        final index_ = index;
        helper.build(context, code, parser, result1, silent, onSuccess: (code) {
          plunge(++index);
        }, onFailure: (code) {
          if (failureIndex == index_) {
            code.labelFailure(key);
          }
        });
      } else {
        helper.build(context, code, parser, result1, silent, onSuccess: (code) {
          _setResults(context, code, result, results);
          code.labelSuccess(key);
        }, onFailure: (code) {
          if (parsers.length == 2) {
            code += pos.isEmpty ? '' : 'state.pos = $pos;';
          }
        });
      }
    }

    plunge(0);
    if (parsers.length != 2) {
      code.ifFailure((code) {
        code += pos.isEmpty ? '' : 'state.pos = $pos;';
        if (failureIndex == -1) {
          code.labelFailure(key);
        }
      });
    }

    return key;
  }

  @override
  bool isAlwaysSuccess() {
    final parsers = _getParsers();
    return parsers.where((e) => e.isAlwaysSuccess()).length == parsers.length;
  }

  List<ParserBuilder<I, dynamic>> _getParsers();

  bool _isVoidResult(int index) {
    return false;
  }

  void _setResults(Context context, CodeGen code, ParserResult result,
      List<ParserResult> results);
}
