import 'dart:collection';

import 'printer.dart';
import 'visitors.dart';

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
  final LinkedList<Statement> statements;

  final Iterable values;

  CaseStatement(this.values, this.statements);

  @override
  T accept<T>(Visitor<T> visitor) {
    return visitor.visitCase(this);
  }

  @override
  void visitChildren(Visitor visitor) {
    for (final item in statements) {
      item.accept(visitor);
    }
  }
}

class ConditionalStatement extends Statement {
  String condition;

  final LinkedList<Statement> elseBranch;

  final LinkedList<Statement> ifBranch;

  ConditionalStatement(this.condition, this.ifBranch, this.elseBranch);

  @override
  T accept<T>(Visitor<T> visitor) {
    return visitor.visitConditional(this);
  }

  @override
  void visitChildren(Visitor visitor) {
    for (var statement in ifBranch) {
      statement.accept(visitor);
    }

    for (var statement in elseBranch) {
      statement.accept(visitor);
    }
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

  final LinkedList<Statement> statements;

  IterationStatement(this.definition, this.statements);

  @override
  T accept<T>(Visitor<T> visitor) {
    return visitor.visitIteration(this);
  }

  @override
  void visitChildren(Visitor visitor) {
    for (var statement in statements) {
      statement.accept(visitor);
    }
  }
}

class ResultAssignmentStatement extends Statement {
  final bool cast;

  final String name;

  final String type;

  final String value;

  ResultAssignmentStatement(this.name, this.type, this.value, this.cast);

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

class Statements extends Statement {
  final LinkedList<Statement> statements;

  Statements(this.statements);

  @override
  T accept<T>(Visitor<T> visitor) {
    return visitor.visitStatements(this);
  }

  @override
  void visitChildren(Visitor visitor) {
    for (var statement in statements) {
      statement.accept(visitor);
    }
  }
}

class SwitchStatement extends Statement {
  final List<CaseStatement> cases;

  final LinkedList<Statement> default_;

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

    for (final statement in default_) {
      statement.accept(visitor);
    }
  }
}
