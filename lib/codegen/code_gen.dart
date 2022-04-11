import 'dart:collection';

import 'statements.dart';

class CodeGen {
  LinkedList<Statement> statements;

  final Map<ParserResult, _Ending> _endings = {};

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

  void if_(String condition, void Function(CodeGen code) if_,
      {void Function(CodeGen code)? else_}) {
    final ifBranch = LinkedList<Statement>();
    final elseBranch = LinkedList<Statement>();
    final statement = ConditionalStatement(condition, ifBranch, elseBranch);
    final statements = this.statements;
    this.statements = ifBranch;
    // TODO
    if_(this);
    if (else_ != null) {
      this.statements = elseBranch;
      else_(this);
    }

    this.statements = statements;
    this + statement;
  }

  void ifChildFailure(ParserResult child, void Function(CodeGen code) if_,
      {void Function(CodeGen code)? else_}) {
    void if2(CodeGen code) {
      code.onChildFailure(child, (code) {
        if_(code);
      });
    }

    void else2(CodeGen code) {
      code.onChildSuccess(child, (code) {
        else_!(code);
      });
    }

    return this.if_('!state.ok', if2, else_: else_ == null ? null : else2);
  }

  void ifChildSuccess(ParserResult child, void Function(CodeGen code) if_,
      {void Function(CodeGen code)? else_}) {
    void if2(CodeGen code) {
      code.onChildSuccess(child, (code) {
        if_(code);
      });
    }

    void else2(CodeGen code) {
      code.onChildFailure(child, (code) {
        else_!(code);
      });
    }

    return this.if_('state.ok', if2, else_: else_ == null ? null : else2);
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
    final statements = this.statements;
    this.statements = statement.statements;
    f(this);
    this.statements = statements;
    this + statement;
  }

  void labelFailure(ParserResult result) {
    final ending = _getEnding(result);
    if (ending.failure != null) {
      throw StateError('Failure label already defined');
    }

    ending.failure = statements;
  }

  void labelSuccess(ParserResult result) {
    final ending = _getEnding(result);
    if (ending.success != null) {
      throw StateError('Success label already defined');
    }

    ending.success = statements;
  }

  void negateState() {
    setState('!state.ok');
  }

  void onChildFailure(ParserResult child, void Function(CodeGen code) f) {
    final ending = _getEnding(child);
    final failure = ending.failure;
    if (failure != null) {
      final statements = this.statements;
      this.statements = failure;
      f(this);
      this.statements = statements;
    } else {
      f(this);
    }
  }

  void onChildSuccess(ParserResult child, void Function(CodeGen code) f) {
    final ending = _getEnding(child);
    final success = ending.success;
    if (success != null) {
      final statements = this.statements;
      this.statements = success;
      f(this);
      this.statements = statements;
    } else {
      f(this);
    }
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

  _Ending _getEnding(ParserResult result) {
    var endings = _endings[result];
    if (endings == null) {
      endings = _Ending();
      _endings[result] = endings;
    }

    return endings;
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

  ParserResult empty() {
    return ParserResult('', '', '');
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
