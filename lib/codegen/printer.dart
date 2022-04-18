import 'statements.dart';
import 'visitors.dart';

class Printer extends Visitor<void> {
  StringSink sink = StringBuffer();

  void print(Statement statement, StringSink sink) {
    this.sink = sink;
    statement.accept(this);
  }

  @override
  void visitAssignment(AssignmentStatement node) {
    final left = node.left;
    final right = node.right;
    sink.write(left);
    sink.write(' = ');
    sink.write(right);
    sink.write(';');
  }

  @override
  void visitBlock(BlockStatement node) {
    final delimited = node.delimited;
    final statements = node.statements;
    if (delimited) {
      sink.write('{');
      if (statements.isNotEmpty) {
        sink.writeln();
      }
    }

    for (final statement in statements) {
      statement.accept(this);
      sink.writeln();
    }

    if (delimited) {
      sink.write('}');
    }
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
    final statement = node.statement;
    final values = node.values;
    for (final value in values) {
      sink.write('case ');
      sink.write(value);
      sink.writeln(':');
    }

    statement.accept(this);
  }

  @override
  void visitConditional(ConditionalStatement node) {
    final condition = node.condition;
    final elseBranch = node.elseBranch;
    final ifBranch = node.ifBranch;
    sink.write('if (');
    sink.write(condition);
    sink.write(') ');
    ifBranch.accept(this);
    if (!elseBranch.isEmptyStatement()) {
      sink.write(' else ');
      elseBranch.accept(this);
    }
  }

  @override
  void visitContinue(ContinueStatement node) {
    sink.write('continue;');
  }

  @override
  void visitIteration(IterationStatement node) {
    final definition = node.definition;
    final statement = node.statement;
    sink.write(definition);
    statement.accept(this);
  }

  @override
  void visitResultAssignment(ResultAssignmentStatement node) {
    final name = node.name;
    final value = node.value;
    sink.write(name);
    sink.write(' = ');
    sink.write(value);
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

    if (default_ is BlockStatement) {
      final statements = default_.statements;
      if (statements.isNotEmpty) {
        sink.writeln('default:');
      }
    } else {
      sink.writeln('default:');
    }

    default_.accept(this);
    sink.write('}');
  }
}
