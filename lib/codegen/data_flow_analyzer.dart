import 'dart:collection';

import 'statements.dart';
import 'visitors.dart';

class DataFlowAnalyzer extends Visitor<void> {
  static const _notStateOk = '!state.ok';

  static const _stateOk = 'state.ok';

  Map<Statement, DataPoint> _dataFlow = {};

  bool _hasContinue = false;

  bool _insideSwitch = false;

  final List<IterationStatement> _iterations = [];

  Statement? _previous;

  Map<Statement, DataPoint> analyze(
      LinkedList<Statement> statements, Map<Statement, DataPoint> dataFlow) {
    _dataFlow = dataFlow;
    _previous = null;
    for (final statement in statements) {
      statement.accept(this);
    }

    if (_hasContinue) {
      _previous = null;
      for (final statement in statements) {
        statement.accept(this);
      }
    }

    return dataFlow;
  }

  @override
  void visitAssignment(AssignmentStatement node) {
    _addFromPrevious(node, true);
    final left = node.left;
    if (_trim(left) == _stateOk) {
      final right = node.right;
      switch (_trim(right)) {
        case 'false':
          _setValueInOutSet(node, _stateOk, false);
          break;
        case 'true':
          _setValueInOutSet(node, _stateOk, true);
          break;
        default:
          _removeKeyInOutSet(node, _stateOk);
      }
    }

    _previous = node;
  }

  @override
  void visitBlock(BlockStatement node) {
    _addFromPrevious(node, false);
    final statements = node.statements;
    final isEmpty = statements.isEmpty;
    if (!isEmpty) {
      final first = statements.first;
      _addValues([node], _DataSetKind.inSet, first, _DataSetKind.inSet);
    }

    _previous = null;
    for (var statement in statements) {
      statement.accept(this);
    }

    if (!isEmpty) {
      final last = statements.last;
      _addValues([last], _DataSetKind.outSet, node, _DataSetKind.outSet);
    } else {
      _propogate(node);
    }

    _previous = node;
  }

  @override
  void visitBreak(BreakStatement node) {
    _addFromPrevious(node, false);
    if (!_insideSwitch) {
      final iteration = _getLastIteration();
      final statement = iteration.statement;
      _addValues([node], _DataSetKind.inSet, statement, _DataSetKind.outSet);
    }

    _previous = node;
  }

  @override
  void visitCall(CallStatement node) {
    _addFromPrevious(node, false);
    _previous = node;
  }

  @override
  void visitCase(CaseStatement node) {
    _addFromPrevious(node, false);
    final statement = node.statement;
    statement.accept(this);
    _addValues([statement], _DataSetKind.outSet, node, _DataSetKind.outSet);
    _previous = node;
  }

  @override
  void visitConditional(ConditionalStatement node) {
    _addFromPrevious(node, false);
    final condition = node.condition;
    final ifBranch = node.ifBranch;
    final elseBranch = node.elseBranch;
    final ifPoint = _getDataPoint(ifBranch);
    final elsePoint = _getDataPoint(elseBranch);
    _addValues([node], _DataSetKind.inSet, ifBranch, _DataSetKind.inSet);
    _addValues([node], _DataSetKind.inSet, elseBranch, _DataSetKind.inSet);
    Object? ifValue;
    Object? elseValue;
    final bool isStateOk;
    switch (_trim(condition)) {
      case _stateOk:
        isStateOk = true;
        ifValue = true;
        elseValue = false;
        break;
      case _notStateOk:
        isStateOk = true;
        ifValue = false;
        elseValue = true;
        break;
      default:
        isStateOk = false;
    }

    if (isStateOk) {
      _setValueInInSet(ifPoint, _stateOk, ifValue);
      _setValueInInSet(elsePoint, _stateOk, elseValue);
    }

    _previous = null;
    ifBranch.accept(this);
    _previous = null;
    elseBranch.accept(this);
    if (isStateOk) {
      final inSet = _getDataSet(node, _DataSetKind.inSet);
      final values = inSet.getValues(_stateOk);
      if (values.isEmpty) {
        _addValues([ifBranch, elseBranch], _DataSetKind.outSet, node,
            _DataSetKind.outSet);
      } else {
        var count = 0;
        if (values.contains(ifValue)) {
          count++;
          _addValues(
              [ifBranch], _DataSetKind.outSet, node, _DataSetKind.outSet);
        }

        if (values.contains(elseValue)) {
          count++;
          _addValues(
              [elseBranch], _DataSetKind.outSet, node, _DataSetKind.outSet);
        }

        if (count == 0) {
          final outSet = _getDataSet(node, _DataSetKind.outSet);
          for (final value in values) {
            outSet.addValue(_stateOk, value);
          }
        }
      }
    } else {
      _addValues([ifBranch, elseBranch], _DataSetKind.outSet, node,
          _DataSetKind.outSet);
    }

    _previous = node;
  }

  @override
  void visitContinue(ContinueStatement node) {
    _addFromPrevious(node, false);
    _hasContinue = true;
    final iteration = _getLastIteration();
    final statement = iteration.statement;
    if (statement is BlockStatement) {
      final statements = statement.statements;
      if (statements.isNotEmpty) {
        final first = statements.first;
        _addValues([node], _DataSetKind.inSet, first, _DataSetKind.inSet);
      }
    } else {
      _addValues([node], _DataSetKind.outSet, statement, _DataSetKind.inSet);
    }

    _previous = node;
  }

  @override
  void visitIteration(IterationStatement node) {
    _addFromPrevious(node, false);
    final insideSwitch = _insideSwitch;
    _insideSwitch = false;
    _iterations.add(node);
    final statement = node.statement;
    _addValues([node], _DataSetKind.inSet, statement, _DataSetKind.inSet);
    _previous = null;
    statement.accept(this);
    _addValues([statement], _DataSetKind.outSet, node, _DataSetKind.outSet);
    _iterations.removeLast();
    _insideSwitch = insideSwitch;
    _previous = node;
  }

  @override
  void visitResultAssignment(ResultAssignmentStatement node) {
    _addFromPrevious(node, true);
    _previous = node;
  }

  @override
  void visitSource(SourceStatement node) {
    _addFromPrevious(node, true);
    _previous = node;
  }

  @override
  void visitStateAssignment(StateAssignmentStatement node) {
    _addFromPrevious(node, true);
    switch (_trim(node.value)) {
      case 'false':
        _setValueInOutSet(node, _stateOk, false);
        break;
      case 'true':
        _setValueInOutSet(node, _stateOk, true);
        break;
      default:
        _removeKeyInOutSet(node, _stateOk);
    }

    _previous = node;
  }

  @override
  void visitSwitch(SwitchStatement node) {
    _addFromPrevious(node, false);
    final insideSwitch = _insideSwitch;
    _insideSwitch = true;
    final cases = node.cases;
    for (final case_ in cases) {
      case_.accept(this);
      _previous = node;
    }

    final default_ = node.default_;
    default_.accept(this);
    _addValues(
        [...cases, default_], _DataSetKind.outSet, node, _DataSetKind.outSet);
    _insideSwitch = insideSwitch;
    _previous = node;
  }

  void _addFromPrevious(Statement node, bool propogate) {
    if (_previous != null) {
      _addValues([_previous!], _DataSetKind.outSet, node, _DataSetKind.inSet);
    }

    if (propogate) {
      _propogate(node);
    }
  }

  void _addValues(List<Statement> from, _DataSetKind fromKind, Statement to,
      _DataSetKind toKind) {
    final toSet = _getDataSet(to, toKind);
    for (final statement in from) {
      final fromSet = _getDataSet(statement, fromKind);
      toSet.addAll(fromSet);
    }
  }

  void _checkIterationsIsNotEmpty() {
    if (_iterations.isEmpty) {
      throw StateError('Outside of iteration');
    }
  }

  DataPoint _getDataPoint(Statement node) {
    var point = _dataFlow[node];
    if (point == null) {
      point = DataPoint(node);
      _dataFlow[node] = point;
    }

    return point;
  }

  DataSet _getDataSet(Statement node, _DataSetKind kind) {
    final point = _getDataPoint(node);
    switch (kind) {
      case _DataSetKind.inSet:
        return point.inSet;
      case _DataSetKind.outSet:
        return point.outSet;
    }
  }

  IterationStatement _getLastIteration() {
    _checkIterationsIsNotEmpty();
    final last = _iterations.last;
    return last;
  }

  void _propogate(Statement node) {
    _addValues([node], _DataSetKind.inSet, node, _DataSetKind.outSet);
  }

  void _removeKeyInOutSet(Statement node, Object key) {
    final point = _getDataPoint(node);
    final outSet = point.outSet;
    outSet.removeKey(key);
  }

  void _setValueInInSet(DataPoint point, Object key, value) {
    final inSet = point.inSet;
    inSet.setValue(key, value);
  }

  void _setValueInOutSet(Statement node, Object key, value) {
    final point = _getDataPoint(node);
    final outSet = point.outSet;
    outSet.setValue(key, value);
  }

  String _trim(String text) {
    return text.replaceAll(' ', '');
  }
}

class DataPoint {
  final Object object;

  final DataSet inSet = DataSet();

  final DataSet outSet = DataSet();

  DataPoint(this.object);

  @override
  String toString() {
    final list = <String>[];
    if (inSet.map.isNotEmpty) {
      final sink = StringBuffer();
      sink.write('in: {');
      sink.write(inSet);
      list.add(sink.toString());
      sink.write('}');
    }

    if (outSet.map.isNotEmpty) {
      final sink = StringBuffer();
      sink.write('out: {');
      sink.write(outSet);
      sink.write('}');
      list.add(sink.toString());
    }

    return list.join(', ');
  }
}

class DataSet {
  final Map<Object, Set> map = {};

  void addAll(DataSet other) {
    final map2 = other.map;
    for (var key in map2.keys) {
      final set2 = other.getValues(key);
      final set = getValues(key);
      set.addAll(set2);
    }
  }

  void addValue(key, value) {
    final values = getValues(key);
    values.add(value);
  }

  void clearAllValues() {
    map.clear();
  }

  void clearValues(key) {
    final values = getValues(key);
    values.clear();
  }

  DataSet copy() {
    final dataSet = DataSet();
    dataSet.addAll(this);
    return dataSet;
  }

  Set getValues(Object key) {
    var values = map[key];
    if (values == null) {
      values = {};
      map[key] = values;
    }

    return values;
  }

  void removeKey(Object key) {
    map.remove(key);
  }

  void setValue(Object key, value) {
    final values = getValues(key);
    values.clear();
    values.add(value);
  }

  @override
  String toString() {
    final list = <String>[];
    for (final key in map.keys) {
      final sink = StringBuffer();
      sink.write(key);
      sink.write(': ');
      sink.write(getValues(key));
      list.add(sink.toString());
    }

    return list.join(', ');
  }
}

enum _DataSetKind { inSet, outSet }
