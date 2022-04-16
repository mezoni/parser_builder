import 'dart:collection';

import 'package:parser_builder/codegen/data_flow_analyzer.dart';

import 'statements.dart';
import 'visitors.dart';

class CodeOptimizer {
  void optimize(LinkedList<Statement> statements) {
    while (true) {
      var hasModifications = false;
      final dataFlowAnalyzer = DataFlowAnalyzer();
      final points = dataFlowAnalyzer.analyze(statements, {});
      final emptyConditiotalRemover = _EmptyConditiotalRemover();
      if (emptyConditiotalRemover.remove(statements)) {
        hasModifications = true;
      }

      final conditiotalWithEmptyIfBranchOptimizer =
          _ConditiotalWithEmptyIfBranchOptimizer();
      if (conditiotalWithEmptyIfBranchOptimizer.optimize(statements)) {
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
      switch (item.condition) {
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
    if (ifBranch.isEmpty && elseBranch.isNotEmpty) {
      final condition = node.condition;
      if (condition == 'state.ok' || condition == '!state.ok') {
        _found.add(node);
      }
    }
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
    if (ifBranch.isEmpty && elseBranch.isEmpty) {
      _found.add(node);
    }
  }
}
