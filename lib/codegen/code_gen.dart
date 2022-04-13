import 'dart:collection';

import 'package:parser_builder/parser_builder.dart';

import 'statements.dart';

class CodeGen {
  LinkedList<Statement> statements;

  final Map<BuidlResult, _Ending> _endings = {};

  CodeGen(this.statements);

  CodeGen operator +(code) {
    addCode(code);
    return this;
  }

  void addCode(code) {
    if (_endsWithTransferControl()) {
      throw StateError('Unable to add statement after transfer of control');
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

  void break$() {
    this + BreakStatement();
  }

  void callParse(String name, ParserResult result) {
    this + CallStatement(name, result.name);
  }

  void continue$() {
    this + ContinueStatement();
  }

  LinkedList<Statement>? getLabelFailure(BuidlResult key) {
    final ending = _getEnding(key);
    return ending.failure;
  }

  LinkedList<Statement>? getLabelSuccess(BuidlResult key) {
    final ending = _getEnding(key);
    return ending.success;
  }

  void if_(String condition, void Function(CodeGen code) if_,
      {void Function(CodeGen code)? else_}) {
    final ifBranch = LinkedList<Statement>();
    final elseBranch = LinkedList<Statement>();
    final statement = ConditionalStatement(condition, ifBranch, elseBranch);
    scope(ifBranch, if_);
    if (else_ != null) {
      scope(elseBranch, else_);
    }

    this + statement;
  }

  void ifFailure(void Function(CodeGen code) if_,
      {void Function(CodeGen code)? else_}) {
    return this.if_('!state.ok', if_, else_: else_);
  }

  void ifSuccess(void Function(CodeGen code) if_,
      {void Function(CodeGen code)? else_}) {
    return this.if_('state.ok', if_, else_: else_);
  }

  void iteration(String definition, void Function(CodeGen code) f) {
    final statement = IterationStatement(definition, LinkedList());
    scope(statement.statements, f);
    this + statement;
  }

  void labelFailure(BuidlResult key) {
    final ending = _getEnding(key);
    if (ending.failure != null) {
      throw StateError('Failure label already defined');
    }

    ending.failure = statements;
  }

  void labelSuccess(BuidlResult key) {
    final ending = _getEnding(key);
    if (ending.success != null) {
      throw StateError('Success label already defined');
    }

    ending.success = statements;
  }

  void negateState() {
    setState('!state.ok');
  }

  void scope(LinkedList<Statement> statements, void Function(CodeGen code) f) {
    final statements_ = this.statements;
    this.statements = statements;
    f(this);
    this.statements = statements_;
  }

  void setFailure() {
    setState('false');
  }

  void setResult(ParserResult result, String value, [bool cast = true]) {
    if (!result.isVoid) {
      if (value.isEmpty) {
        throw ArgumentError('Value must be specified', 'value');
      }

      if (value.trim() != 'null') {
        this + ResultAssignmentStatement(result.name, result.type, value, cast);
      }
    }
  }

  void setState(String value) {
    this + StateAssignmentStatement(value);
  }

  void setSuccess() {
    setState('true');
  }

  void switch_(value, void Function(SwitchCodeGen code) f) {
    final cases = <CaseStatement>[];
    final default_ = LinkedList<Statement>();
    final statement = SwitchStatement(value, cases, default_);
    final statements = this.statements;
    f(SwitchCodeGen(statement, this));
    this.statements = statements;
    this + statement;
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

  _Ending _getEnding(BuidlResult key) {
    var endings = _endings[key];
    if (endings == null) {
      endings = _Ending();
      _endings[key] = endings;
    }

    return endings;
  }
}

class ParserResult {
  final String name;

  final String type;

  final String value;

  final String valueUnsafe;

  const ParserResult(this.name, this.type, this.value, this.valueUnsafe);

  bool get isVoid {
    return type.trim() == 'void';
  }
}

class SwitchCodeGen {
  final CodeGen _code;

  final SwitchStatement _switch;

  SwitchCodeGen(this._switch, this._code);

  void case_(Iterable values, void Function(CodeGen code) case_) {
    final branch = LinkedList<Statement>();
    final statements = _code.statements;
    _code.statements = branch;
    case_(_code);
    _code.statements = statements;
    _switch.cases.add(CaseStatement(values, branch));
  }

  void default_(List values, void Function(CodeGen code) case_) {
    final default_ = _switch.default_;
    if (default_.isNotEmpty) {
      throw StateError('Default branch already contains statements');
    }

    final statements = _code.statements;
    _code.statements = default_;
    case_(_code);
    _code.statements = statements;
  }
}

class _Ending {
  LinkedList<Statement>? failure;

  LinkedList<Statement>? success;
}
