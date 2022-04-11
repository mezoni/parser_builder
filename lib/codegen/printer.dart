import 'dart:collection';

import 'statements.dart';
import 'visitors.dart';

class Printer extends Visitor<void> {
  StringSink sink = StringBuffer();

  void print(Statement statement, StringSink sink) {
    this.sink = sink;
    statement.accept(this);
  }

  @override
  void visitBreak(BreakStatement node) {
    sink.write('break;');
  }

  @override
  void visitCall(CallStatement node) {
    final name = node.name;
    final result = node.result;
    if (result.isNotEmpty) {
      sink.write(result);
      sink.write(' = ');
    }

    sink.write(name);
    sink.write('(state);');
  }

  @override
  void visitCase(CaseStatement node) {
    final statements = node.statements;
    final values = node.values;
    for (final value in values) {
      sink.write('case ');
      sink.write(value);
      sink.writeln(':');
    }

    _visitStatements(statements);
  }

  @override
  void visitConditional(ConditionalStatement node) {
    final condition = node.condition;
    final elseBranch = node.elseBranch;
    final ifBranch = node.ifBranch;
    sink.write('if (');
    sink.write(condition);
    sink.writeln(') {');
    _visitStatements(ifBranch);
    if (elseBranch.isNotEmpty) {
      sink.writeln('} else {');
      _visitStatements(elseBranch);
    }

    sink.write('}');
  }

  @override
  void visitContinue(ContinueStatement node) {
    sink.write('continue;');
  }

  @override
  void visitIteration(IterationStatement node) {
    final definition = node.definition;
    final statements = node.statements;
    sink.write(definition);
    sink.writeln(' {');
    _visitStatements(statements);
    sink.write('}');
  }

  @override
  void visitResultAssignment(ResultAssignmentStatement node) {
    final cast = node.cast;
    final name = node.name;
    final value = node.value;
    sink.write(name);
    sink.write(' = ');
    sink.write(value);
    if (cast) {
      final type = node.type;
      sink.write(' as ');
      sink.write(type);
    }

    sink.write(';');
  }

  @override
  void visitSource(SourceStatement node) {
    final source = node.source;
    sink.write(source);
  }

  @override
  void visitStateAssignment(StateAssignmentStatement node) {
    final value = node.value;
    sink.write('state.ok = ');
    sink.write(value);
    sink.write(';');
  }

  @override
  void visitSwitch(SwitchStatement node) {
    final default_ = node.default_;
    final cases = node.cases;
    final value = node.value;
    sink.write('switch (');
    sink.write(value);
    sink.writeln(') {');
    for (final item in cases) {
      item.accept(this);
    }

    if (default_.isNotEmpty) {
      sink.writeln('default:');
      _visitStatements(default_);
    }
    sink.write('}');
  }

  void _visitStatements(LinkedList<Statement> statements) {
    for (final statement in statements) {
      statement.accept(this);
      sink.writeln();
    }
  }
}
