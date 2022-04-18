import 'dart:collection';

import 'package:parser_builder/codegen/code_gen.dart';
import 'package:parser_builder/codegen/data_flow_analyzer.dart';
import 'package:parser_builder/codegen/statements.dart';
import 'package:parser_builder/parser_builder.dart';
import 'package:test/test.dart';

void main(List<String> args) {
  test('description', () {
    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.if_('any', (code) {
        code.setFailure();
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {false, true});
    }
  });

  _testConditional();
  _testIteration();
  _testSetStateOk();
}

const _stateOk = 'state.ok';

Map<Statement, DataPoint> _analyze(LinkedList<Statement> statements) {
  final analyzer = DataFlowAnalyzer();
  final dataFlow = analyzer.analyze(statements, {});
  return dataFlow;
}

CodeGen _getCode(LinkedList<Statement> statements) {
  final allocator = Allocator('\$');
  final name = allocator.allocate('x');
  final result = ParserResult(name, 'int', name);
  final code = CodeGen(statements, allocator: allocator, result: result);
  return code;
}

DataPoint _getDataPoint(
    Statement statement, Map<Statement, DataPoint> dataFlow) {
  var point = dataFlow[statement];
  if (point == null) {
    point = DataPoint(statement);
    dataFlow[statement] = point;
  }

  return point;
}

void _testConditional() {
  test('Conditional', () {
    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.setFailure();
      code.ifSuccess((code) {
        //
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {false});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.setState('any');
      code.ifSuccess((code) {
        //
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {false, true});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.setState('any');
      code.ifSuccess((code) {
        code.setFailure();
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {false});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.setState('any');
      code.ifSuccess((code) {
        code.setFailure();
      }, else_: (code) {
        code.setFailure();
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {false});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.setState('any');
      code.ifSuccess((code) {
        code.setFailure();
      }, else_: (code) {
        code.setSuccess();
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {false, true});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.ifSuccess((code) {
        code.setFailure();
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {false});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.if_('any', (code) {
        code.setFailure();
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {false, true});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.setState('any');
      code.if_('any', (code) {
        code.setFailure();
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {false, null});
    }
  });
}

void _testIteration() {
  test('Iteration', () {
    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.while$('true', (code) {
        code.setFailure();
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {false});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.while$('true', (code) {
        code.ifSuccess((code) {
          //
        });
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {true, false});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.while$('true', (code) {
        code.ifSuccess((code) {
          code.setFailure();
        });
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {false});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.while$('true', (code) {
        code.ifSuccess((code) {
          code.setState('any');
        });
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {false, null});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.setState('any');
      code.while$('true', (code) {
        code.if_('any', (code) {
          code.break$();
        });

        code.setSuccess();
        code.continue$();
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {true, null});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.setState('x');
      code.while$('true', (code) {
        code.ifFailure((code) {
          code.break$();
        });
        code.setSuccess();
        code.continue$();
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {false});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.setState('any');
      code.while$('true', (code) {
        code.ifFailure((code) {
          code.break$();
        }, else_: (code) {
          code.break$();
        });
        code.setSuccess();
        code.continue$();
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {false, true});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.while$('true', (code) {
        code.setState('any');
        code.ifFailure((code) {
          code.break$();
        });
        code.setSuccess();
        code.continue$();
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {false});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.while$('true', (code) {
        code.setState('any');
        code.ifFailure((code) {
          code.break$();
        });
        code.continue$();
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {false});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.while$('true', (code) {
        code.setState('any');
        code.if_('any', (code) {
          code.break$();
        });
        code.setSuccess();
        code.continue$();
      });
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {null});
    }
  });
}

void _testSetStateOk() {
  test('Set state.ok', () {
    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.setFailure();
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {false});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.setSuccess();
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {true});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.setState('any');
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {null});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.setFailure();
      code.setState('any');
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {null});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.setState('true');
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {true});
    }

    {
      final statements = LinkedList<Statement>();
      final code = _getCode(statements);
      code.setState('false');
      final dataFlow = _analyze(statements);
      final last = statements.last;
      final p1 = _getDataPoint(last, dataFlow);
      expect(p1.outSet.getValues(_stateOk), {false});
    }
  });
}
