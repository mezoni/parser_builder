part of '../../sequence.dart';

abstract class _Sequence<I, O> extends ParserBuilder<I, O> {
  const _Sequence();

  @override
  void build(Context context, CodeGen code) {
    final parsers = _getParsers();
    if (parsers.length < 2) {
      throw StateError('The list of parsers must contain at least 2 elements');
    }

    final pos = code.savePos();
    final results = <ParserResult>[];
    void plunge(int index) {
      final parser = parsers[index];
      final fast = _isVoidResult(index) ? true : code.fast;
      if (index < parsers.length - 1) {
        final pos_ = index == 0 ? pos : null;
        final result =
            helper.build(context, code, parser, fast: fast, pos: pos_);
        code.ifSuccess((code) {
          results.add(result);
          plunge(++index);
        });
      } else {
        final result = helper.build(context, code, parser, fast: fast);
        code.ifSuccess((code) {
          results.add(result);
          _setResult(context, code, results);
        }, else_: (code) {
          if (parsers.length == 2) {
            code.setPos(pos);
          }
        });
      }
    }

    plunge(0);
    if (parsers.length != 2) {
      code.ifFailure((code) {
        code.setPos(pos);
      });
    }
  }

  List<ParserBuilder<I, dynamic>> _getParsers();

  bool _isVoidResult(int index) {
    return false;
  }

  void _setResult(Context context, CodeGen code, List<ParserResult> results);
}
