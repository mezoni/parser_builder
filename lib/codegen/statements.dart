import 'dart:collection';

import 'printer.dart';
import 'visitors.dart';

class AssignmentStatement extends Statement {
  final String left;

  final String right;

  AssignmentStatement(this.left, this.right);

  @override
  T accept<T>(Visitor<T> visitor) {
    return visitor.visitAssignment(this);
  }
}

class BlockStatement extends Statement {
  final bool delimited;

  final LinkedList<Statement> statements;

  BlockStatement(this.statements, this.delimited);

  @override
  T accept<T>(Visitor<T> visitor) {
    return visitor.visitBlock(this);
  }

  @override
  bool isEmptyStatement() {
    return statements.isEmpty;
  }

  @override
  void visitChildren(Visitor visitor) {
    for (final statement in statements) {
      statement.accept(visitor);
    }
  }
}

class BreakStatement extends Statement {
  @override
  T accept<T>(Visitor<T> visitor) {
    return visitor.visitBreak(this);
  }
}

class CallStatement extends Statement {
  final String name;

  final String result;

  CallStatement(this.name, this.result);

  @override
  T accept<T>(Visitor<T> visitor) {
    return visitor.visitCall(this);
  }
}

class CaseStatement extends Statement {
  final Statement statement;

  final Iterable values;

  CaseStatement(this.values, this.statement);

  @override
  T accept<T>(Visitor<T> visitor) {
    return visitor.visitCase(this);
  }

  @override
  void visitChildren(Visitor visitor) {
    statement.accept(visitor);
  }
}

class ConditionalStatement extends Statement {
  String condition;

  final Statement elseBranch;

  final Statement ifBranch;

  ConditionalStatement(this.condition, this.ifBranch, this.elseBranch);

  @override
  T accept<T>(Visitor<T> visitor) {
    return visitor.visitConditional(this);
  }

  @override
  void visitChildren(Visitor visitor) {
    ifBranch.accept(visitor);
    elseBranch.accept(visitor);
  }
}

class ContinueStatement extends Statement {
  @override
  T accept<T>(Visitor<T> visitor) {
    return visitor.visitContinue(this);
  }
}

class IterationStatement extends Statement {
  final String definition;

  final Statement statement;

  IterationStatement(this.definition, this.statement);

  @override
  T accept<T>(Visitor<T> visitor) {
    return visitor.visitIteration(this);
  }

  @override
  void visitChildren(Visitor visitor) {
    statement.accept(visitor);
  }
}

class ResultAssignmentStatement extends Statement {
  final String name;

  final String type;

  final String value;

  ResultAssignmentStatement(this.name, this.type, this.value);

  @override
  T accept<T>(Visitor<T> visitor) {
    return visitor.visitResultAssignment(this);
  }
}

class SourceStatement extends Statement {
  final String source;

  SourceStatement(this.source);

  @override
  T accept<T>(Visitor<T> visitor) {
    return visitor.visitSource(this);
  }
}

class StateAssignmentStatement extends Statement {
  final String value;

  StateAssignmentStatement(this.value);

  @override
  T accept<T>(Visitor<T> visitor) {
    return visitor.visitStateAssignment(this);
  }
}

abstract class Statement extends LinkedListEntry<Statement> {
  T accept<T>(Visitor<T> visitor);

  bool isEmptyStatement() {
    return false;
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    final printer = Printer();
    printer.print(this, buffer);
    return buffer.toString();
  }

  void visitChildren(Visitor visitor) {
    return;
  }
}

class SwitchStatement extends Statement {
  final List<CaseStatement> cases;

  final Statement default_;

  final String value;

  SwitchStatement(this.value, this.cases, this.default_);

  @override
  T accept<T>(Visitor<T> visitor) {
    return visitor.visitSwitch(this);
  }

  @override
  void visitChildren(Visitor visitor) {
    for (final item in cases) {
      item.accept(visitor);
    }

    default_.accept(visitor);
  }
}
