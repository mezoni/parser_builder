import 'statements.dart';

abstract class Visitor<T> {
  T visitAssignment(AssignmentStatement node);

  T visitBlock(BlockStatement node);

  T visitBreak(BreakStatement node);

  T visitCall(CallStatement node);

  T visitCase(CaseStatement node);

  T visitConditional(ConditionalStatement node);

  T visitContinue(ContinueStatement node);

  T visitIteration(IterationStatement node);

  T visitResultAssignment(ResultAssignmentStatement node);

  T visitSource(SourceStatement node);

  T visitStateAssignment(StateAssignmentStatement node);

  T visitSwitch(SwitchStatement node);
}

abstract class VisitorBase<T> extends Visitor<T> {
  T visit(Statement node);

  @override
  T visitAssignment(AssignmentStatement node) => visit(node);

  @override
  T visitBlock(BlockStatement node) => visit(node);

  @override
  T visitBreak(BreakStatement node) => visit(node);

  @override
  T visitCall(CallStatement node) => visit(node);

  @override
  T visitCase(CaseStatement node) => visit(node);

  @override
  T visitConditional(ConditionalStatement node) => visit(node);

  @override
  T visitContinue(ContinueStatement node) => visit(node);

  @override
  T visitIteration(IterationStatement node) => visit(node);

  @override
  T visitResultAssignment(ResultAssignmentStatement node) => visit(node);

  @override
  T visitSource(SourceStatement node) => visit(node);

  @override
  T visitStateAssignment(StateAssignmentStatement node) => visit(node);

  @override
  T visitSwitch(SwitchStatement node) => visit(node);
}
