part of '../../parser_builder.dart';

abstract class CharPredicate {
  bool get has32BitChars;
}

class ClosureTransformer<I, O> extends Transformer<I, O> {
  final String expression;

  const ClosureTransformer(this.expression);

  @override
  String declare(String name) {
    return 'final $name = $expression;';
  }

  @override
  String invoke(String name, String argument) {
    return '$name($argument)';
  }
}

class ExprTransformer<I, O> extends Transformer<I, O> {
  final String expression;

  final String parameter;

  const ExprTransformer(this.parameter, this.expression);

  @override
  bool get canInline => true;

  @override
  String declare(String name) {
    final expr = _transform(parameter);
    return '$O ($I $parameter) => $expr;';
  }

  @override
  String inline(String value) {
    final expr = _transform(value);
    return expr;
  }

  @override
  String invoke(String name, String argument) {
    return '$name($argument)';
  }

  String _transform(String argument) {
    return expression.replaceAll('{{$parameter}}', argument);
  }
}

class FuncExprTransformer<I, O> extends Transformer<I, O> {
  final String expression;

  final String parameter;

  const FuncExprTransformer(this.parameter, this.expression);

  @override
  String declare(String name) {
    return '$O $name($I $parameter) => $expression;';
  }

  @override
  String invoke(String name, String argument) {
    return '$name($argument)';
  }
}

class FuncTransformer<I, O> extends Transformer<I, O> {
  final String body;

  final String parameter;

  const FuncTransformer(this.parameter, this.body);

  @override
  String declare(String name) {
    return '$O $name($I $parameter) {$body }';
  }

  @override
  String invoke(String name, String argument) {
    return '$name($argument)';
  }
}

abstract class Transformer<I, O> {
  const Transformer();

  bool get canInline => false;

  String declare(String name);

  String inline(String value) {
    throw UnimplementedError('inline');
  }

  String invoke(String name, String argument);
}

class VarTransformer<I, O> extends Transformer<I, O> {
  final String expression;

  const VarTransformer(this.expression);

  @override
  String declare(String name) {
    return 'final $name = $expression;';
  }

  @override
  String invoke(String name, String argument) {
    return name;
  }
}
