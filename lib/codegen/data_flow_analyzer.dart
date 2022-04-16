import 'dart:collection';

import 'statements.dart';
import 'visitors.dart';

class DataFlowAnalyzer extends Visitor<void> {
  static const _stateOk = 'state.ok';

  bool _hasContinue = false;

  bool _insideSwitch = false;

  final List<IterationStatement> _iterations = [];

  DataPoint _point = DataPoint(Object());

  Map<Statement, DataPoint> _points = {};

  Map<Statement, DataPoint> analyze(
      LinkedList<Statement> statements, Map<Statement, DataPoint> points) {
    _points = points;
    for (final statement in statements) {
      statement.accept(this);
    }

    if (_hasContinue) {
      for (final statement in statements) {
        statement.accept(this);
      }
    }

    return points;
  }

  @override
  void visitAssignment(AssignmentStatement node) {
    final point = _addPoint(node, _point);
    final left = node.left;
    if (_trim(left) == 'state.ok') {
      final right = node.right;
      final bool? value;
      switch (_trim(right)) {
        case 'false':
          value = false;
          break;
        case 'true':
          value = true;
          break;
        default:
          value = null;
      }

      point.setValue(_stateOk, value);
    }
  }

  @override
  void visitBreak(BreakStatement node) {
    final point = _addPoint(node, _point);
    if (!_insideSwitch) {
      final iteration = _getLastIteration();
      final statements = iteration.statements;
      if (statements.isNotEmpty) {
        final last = statements.last;
        final point2 = _getDataPoint(last);
        point2.addAll(point);
      }
    }
  }

  @override
  void visitCall(CallStatement node) {
    _addPoint(node, _point);
  }

  @override
  void visitCase(CaseStatement node) {
    final point = _addPoint(node, _point);
    final statements = node.statements;
    _visitStatements(statements, point);
  }

  @override
  void visitConditional(ConditionalStatement node) {
    final point = _addPoint(node, _point);
    final condition = node.condition;
    final ifBranch = node.ifBranch;
    final elseBranch = node.elseBranch;
    final temp = _trim(condition);
    if (temp == _stateOk || temp == '!$_stateOk') {
      final stateOk = temp == _stateOk ? true : false;
      if (ifBranch.isNotEmpty) {
        final first = ifBranch.first;
        final point = _getDataPoint(first);
        point.setValue(_stateOk, stateOk);
      } else {
        point.addValue(_stateOk, stateOk);
      }

      if (elseBranch.isNotEmpty) {
        final first = elseBranch.first;
        final point = _getDataPoint(first);
        point.setValue(_stateOk, !stateOk);
      } else {
        point.addValue(_stateOk, !stateOk);
      }
    }

    _visitStatements(ifBranch, point);
    _visitStatements(elseBranch, point);
  }

  @override
  void visitContinue(ContinueStatement node) {
    final point = _addPoint(node, _point);
    _hasContinue = true;
    if (!_insideSwitch) {
      final iteration = _getLastIteration();
      final statements = iteration.statements;
      if (statements.isNotEmpty) {
        final first = statements.first;
        final point2 = _getDataPoint(first);
        point2.addAll(point);
      }
    }
  }

  @override
  void visitIteration(IterationStatement node) {
    final point = _addPoint(node, _point);
    final insideSwitch = _insideSwitch;
    _insideSwitch = false;
    _iterations.add(node);
    final statements = node.statements;
    _visitStatements(statements, point);
    _iterations.removeLast();
    _insideSwitch = insideSwitch;
  }

  @override
  void visitResultAssignment(ResultAssignmentStatement node) {
    _addPoint(node, _point);
  }

  @override
  void visitSource(SourceStatement node) {
    _addPoint(node, _point);
  }

  @override
  void visitStateAssignment(StateAssignmentStatement node) {
    final point = _addPoint(node, _point);
    final bool? value;
    switch (_trim(node.value)) {
      case 'false':
        value = false;
        break;
      case 'true':
        value = true;
        break;
      default:
        value = null;
    }

    point.setValue(_stateOk, value);
  }

  @override
  void visitSwitch(SwitchStatement node) {
    final point = _getDataPoint(node);
    final insideSwitch = _insideSwitch;
    _insideSwitch = true;
    final cases = node.cases;
    for (final case_ in cases) {
      case_.accept(this);
      point.addAll(_point);
      _point = point;
    }

    final default_ = node.default_;
    _visitStatements(default_, point);
    _insideSwitch = insideSwitch;
  }

  DataPoint _addPoint(Statement node, DataPoint point) {
    final point2 = _getDataPoint(node);
    point2.addAll(point);
    _point = point2;
    return point2;
  }

  void _checkIterationsIsNotEmpty() {
    if (_iterations.isEmpty) {
      throw StateError('Outside of iteration');
    }
  }

  DataPoint _getDataPoint(Statement node) {
    var point = _points[node];
    if (point == null) {
      point = DataPoint(node);
      _points[node] = point;
    }

    return point;
  }

  IterationStatement _getLastIteration() {
    _checkIterationsIsNotEmpty();
    final last = _iterations.last;
    return last;
  }

  String _trim(String text) {
    return text.replaceAll(' ', '');
  }

  void _visitStatements(LinkedList<Statement> statements, DataPoint point) {
    if (statements.isNotEmpty) {
      for (final statement in statements) {
        statement.accept(this);
      }

      final last = statements.last;
      final point2 = _getDataPoint(last);
      point.addAll(point2);
    }

    _point = point;
  }
}

class DataPoint {
  final Object object;

  final Map<Object, Set> map = {};

  DataPoint(this.object);

  void addAll(DataPoint other) {
    for (var key in map.keys) {
      final set = map[key]!;
      final set2 = other.getValues(key);
      set.addAll(set2);
    }
  }

  void addValue(key, value) {
    final values = getValues(key);
    values.add(value);
  }

  void clearValues(key) {
    final values = getValues(key);
    values.clear();
  }

  DataPoint copy(Object object) {
    final dataFlow = DataPoint(object);
    dataFlow.addAll(this);
    return dataFlow;
  }

  Set getValues(Object key) {
    var values = map[key];
    if (values == null) {
      values = {};
      map[key] = values;
    }

    return values;
  }

  void setValue(Object key, value) {
    final values = getValues(key);
    values.clear();
    values.add(value);
  }
}
