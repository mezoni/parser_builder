part of '../../error.dart';

abstract class _Fail<I, O> extends ParserBuilder<I, O> {
  const _Fail();

  String _getFailPos(FailPos? pos) {
    if (pos == null) {
      return '-1';
    }

    switch (pos) {
      case FailPos.pos:
        return 'state.pos';
      case FailPos.lastErrorPos:
        return 'state.lastErrorPos';
      case FailPos.start:
        return 'state.start';
    }
  }
}
