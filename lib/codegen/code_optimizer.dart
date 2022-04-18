import 'dart:collection';

import 'package:parser_builder/codegen/data_flow_analyzer.dart';

import 'statements.dart';
import 'visitors.dart';

class CodeOptimizer {
  void optimize(LinkedList<Statement> statements) {
    //_optimizeStateOkAssignments(statements);
    _optimizeConditiotalWithEmptyIfBranch(statements);
    _removeEmptyCondionals(statements);
  }

  Map<Statement, DataPoint> _analyzeDataFlow(LinkedList<Statement> statements) {
    final dataFlowAnalyzer = DataFlowAnalyzer();
    final dataFlow = dataFlowAnalyzer.analyze(statements, {});
    return dataFlow;
  }

  void _optimizeConditiotalWithEmptyIfBranch(LinkedList<Statement> statements) {
    while (true) {
      var hasModifications = false;
      final optimizer = _ConditiotalWithEmptyIfBranchOptimizer();
      if (optimizer.optimize(statements)) {
        hasModifications = true;
      }

      if (!hasModifications) {
        break;
      }
    }
  }

  void _optimizeStateOkAssignments(LinkedList<Statement> statements) {
    while (true) {
      var hasModifications = false;
      final dataFlow = _analyzeDataFlow(statements);
      final optimizer = _StateOkAssignmentOptimizer();
      hasModifications = optimizer.optimize(statements, dataFlow);
      if (!hasModifications) {
        break;
      }
    }
  }

  void _removeEmptyCondionals(LinkedList<Statement> statements) {
    while (true) {
      var hasModifications = false;
      final remover = _EmptyConditiotalRemover();
      if (remover.remove(statements)) {
        hasModifications = true;
      }

      if (!hasModifications) {
        break;
      }
    }
  }
}

class _ConditiotalWithEmptyIfBranchOptimizer extends VisitorBase<void> {
  final List<ConditionalStatement> _found = [];

  bool optimize(LinkedList<Statement> statements) {
    _found.clear();
    for (final statement in statements) {
      statement.accept(this);
    }

    for (final item in _found) {
      final String condition;
      switch (_trim(item.condition)) {
        case 'state.ok':
          condition = '!state.ok';
          break;
        case '!state.ok':
          condition = 'state.ok';
          break;
        default:
          throw StateError('Internal error');
      }

      final elseBranch = item.elseBranch;
      final ifBranch = item.ifBranch;
      final item2 = ConditionalStatement(condition, elseBranch, ifBranch);
      item.insertBefore(item2);
      item.unlink();
    }

    return _found.isNotEmpty;
  }

  @override
  void visit(Statement node) {
    node.visitChildren(this);
  }

  @override
  void visitConditional(ConditionalStatement node) {
    node.visitChildren(this);
    final elseBranch = node.elseBranch;
    final ifBranch = node.ifBranch;
    if (ifBranch.isEmptyStatement() && !elseBranch.isEmptyStatement()) {
      final condition = _trim(node.condition);
      if (condition == 'state.ok' || condition == '!state.ok') {
        _found.add(node);
      }
    }
  }

  String _trim(String text) {
    return text.replaceAll(' ', '');
  }
}

class _EmptyConditiotalRemover extends VisitorBase<void> {
  final List<ConditionalStatement> _found = [];

  bool remove(LinkedList<Statement> statements) {
    _found.clear();
    for (final statement in statements) {
      statement.accept(this);
    }

    for (final item in _found) {
      item.unlink();
    }

    return _found.isNotEmpty;
  }

  @override
  void visit(Statement node) {
    node.visitChildren(this);
  }

  @override
  void visitConditional(ConditionalStatement node) {
    node.visitChildren(this);
    final elseBranch = node.elseBranch;
    final ifBranch = node.ifBranch;
    if (ifBranch.isEmptyStatement() && elseBranch.isEmptyStatement()) {
      _found.add(node);
    }
  }
}

class _StateOkAssignmentOptimizer extends VisitorBase<void> {
  static const _stateOk = 'state.ok';

  Map<Statement, DataPoint> _dataFlow = {};

  List<Statement> _found = [];

  bool optimize(
      LinkedList<Statement> statements, Map<Statement, DataPoint> dataFlow) {
    _dataFlow = dataFlow;
    _found = [];
    for (final statement in statements) {
      statement.accept(this);
    }

    return _found.isNotEmpty;
  }

  @override
  void visit(Statement node) {
    node.visitChildren(this);
  }

  @override
  void visitStateAssignment(StateAssignmentStatement node) {
    final previous = node.previous;
    if (previous != null) {
      //
    }
  }
}
