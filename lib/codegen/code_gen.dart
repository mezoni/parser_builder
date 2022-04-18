import 'dart:collection';

import '../parser_builder.dart';
import 'statements.dart';

class CodeGen {
  final Allocator allocator;

  bool fast;

  ParserResult result;

  String? pos;

  bool silent;

  LinkedList<Statement> statements;

  CodeGen(this.statements,
      {required this.allocator,
      this.fast = false,
      this.pos,
      required this.result,
      this.silent = false});

  CodeGen operator +(code) {
    add(code);
    return this;
  }

  void add(code, [bool? fast]) {
    if (_endsWithTransferControl()) {
      throw StateError('Unable to add statement after transfer of control');
    }

    if (!_testFast(fast)) {
      return;
    }

    if (code is String) {
      if (code.trim().isEmpty) {
        return;
      }

      statements.add(SourceStatement(code));
    } else if (code is Statement) {
      statements.add(code);
    } else {
      throw ArgumentError.value(code, 'code', 'Unknown code type: $code');
    }
  }

  void addCase(SwitchStatement statement, Iterable values,
      void Function(CodeGen code) f) {
    final statements = LinkedList<Statement>();
    final case_ = CaseStatement(values, BlockStatement(statements, false));
    statement.cases.add(case_);
    scope(statements, f);
  }

  void addTo(String name, value, [bool? fast]) {
    if (!_testFast(fast)) {
      return;
    }

    if (value is int) {
      switch (value) {
        case 1:
          this + '$name++;';
          break;
        case -1:
          this + '$name--;';
          break;
        default:
          if (value > 0) {
            this + '$name += $value;';
          } else {
            this + '$name -= $value;';
          }
      }
    } else {
      this + '$name += $value;';
    }
  }

  void addToPos(value) {
    addTo('state.pos', value);
  }

  String allocate(String name, [bool? fast]) {
    if (_testFast(fast)) {
      return allocator.allocate(name);
    } else {
      return '';
    }
  }

  void assign(String left, String right, [bool? fast]) {
    if (_testFast(fast)) {
      this + AssignmentStatement(left, right);
    }
  }

  void break$() {
    this + BreakStatement();
  }

  void callParse(String name, ParserResult result) {
    this + CallStatement(name, result.name);
  }

  void clearResult() {
    if (result.isVoid) {
      return;
    }

    this + ResultAssignmentStatement(result.name, result.type, 'null');
  }

  void continue$() {
    this + ContinueStatement();
  }

  void errorUnexpectedEof([String pos = 'state.pos']) {
    setError('ErrUnexpected.eof($pos)');
  }

  void if_(String condition, void Function(CodeGen code) if_,
      {void Function(CodeGen code)? else_}) {
    final ifBranch = BlockStatement(LinkedList(), true);
    final elseBranch = BlockStatement(LinkedList(), true);
    final statement = ConditionalStatement(condition, ifBranch, elseBranch);
    scope(ifBranch.statements, if_);
    if (else_ != null) {
      scope(elseBranch.statements, else_);
    }

    this + statement;
  }

  void ifFailure(void Function(CodeGen code) if_,
      {void Function(CodeGen code)? else_}) {
    return this.if_('!state.ok', if_, else_: else_);
  }

  void ifNotEof(void Function(CodeGen code) if_,
      {void Function(CodeGen code)? else_}) {
    return this.if_('state.pos < source.length', if_, else_: else_);
  }

  void ifSuccess(void Function(CodeGen code) if_,
      {void Function(CodeGen code)? else_}) {
    return this.if_('state.ok', if_, else_: else_);
  }

  void isEof() {
    setState('state.pos >= source.length');
  }

  void isNotEof() {
    setState('state.pos < source.length');
  }

  void iteration(String definition, void Function(CodeGen code) f) {
    final block = BlockStatement(LinkedList(), true);
    final statement = IterationStatement(definition, block);
    scope(block.statements, f);
    this + statement;
  }

  String local(String type, String name, [String? value, bool? fast]) {
    if (_testFast(fast)) {
      final ident = allocate(name, fast);
      if (value != null) {
        this + '$type $ident = $value;';
      } else {
        this + '$type $ident;';
      }

      return ident;
    } else {
      return '';
    }
  }

  void negateState() {
    setState('!state.ok');
  }

  String savePos([bool? fast]) {
    if (!_testFast(fast)) {
      return '';
    }

    if (pos != null) {
      return pos!;
    }

    pos = val('pos', 'state.pos');
    return pos!;
  }

  void scope(LinkedList<Statement> statements, void Function(CodeGen code) f) {
    final statements_ = this.statements;
    this.statements = statements;
    f(this);
    this.statements = statements_;
  }

  void setError(String error) {
    if (!silent) {
      add('state.error = $error;');
    }
  }

  void setFailure() {
    setState('false');
  }

  void setPos(String value, [bool? fast]) {
    if (_testFast(fast)) {
      assign('state.pos', value);
    }
  }

  void setResult(String value, [bool asNullable = true]) {
    if (!result.isVoid) {
      if (value.isEmpty) {
        throw ArgumentError('Value must be specified', 'value');
      }

      if (value.trim() != 'null') {
        if (asNullable) {
          value = '_wrap($value)';
        }

        this + ResultAssignmentStatement(result.name, result.type, value);
      }
    }
  }

  void setState(String value, [bool? fast]) {
    if (_testFast(fast)) {
      this + StateAssignmentStatement(value);
    }
  }

  void setSuccess() {
    setState('true');
  }

  SwitchStatement switch_(value) {
    final cases = <CaseStatement>[];
    final default_ = BlockStatement(LinkedList(), false);
    final statement = SwitchStatement(value, cases, default_);
    this + statement;
    return statement;
  }

  String val(String name, String? value, [bool? fast]) {
    return local('final', name, value, fast);
  }

  void while$(String condition, void Function(CodeGen code) f) {
    iteration('while ($condition)', f);
  }

  bool _endsWithTransferControl() {
    if (statements.isEmpty) {
      return false;
    }

    final last = statements.last;
    if (last is BreakStatement) {
      return true;
    } else if (last is ContinueStatement) {
      return true;
    }

    return false;
  }

  bool _testFast(bool? fast) {
    fast ??= this.fast;
    return fast == this.fast;
  }
}

class ParserResult {
  final String name;

  final String type;

  final String value;

  const ParserResult(this.name, this.type, this.value);

  bool get isVoid {
    return type.trim() == 'void';
  }
}
