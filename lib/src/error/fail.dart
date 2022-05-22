part of '../../error.dart';

abstract class _Fail<I, O> extends ParserBuilder<I, O> {
  const _Fail();

  String _getFailPos(StatePos? pos) {
    if (pos == null) {
      return '-1';
    }

    switch (pos) {
      case StatePos.pos:
        return 'state.pos';
      case StatePos.lastErrorPos:
        return 'state.lastErrorPos';
      case StatePos.start:
        return 'state.start';
    }
  }
}
