part of '../../parser_builder.dart';

abstract class CharPredicate {
  bool get has32BitChars;
}

class ClosureTransformer<I, O> extends Transformer<I, O> {
  final String expression;

  const ClosureTransformer(this.expression);

  @override
  String declare(Context context, String name) {
    return 'final $name = $expression;';
  }

  @override
  String invoke(Context context, String name, String value) {
    return '$name($value)';
  }
}

class ExprTransformer<I, O> extends Transformer<I, O> {
  final String expression;

  final String parameter;

  const ExprTransformer(this.parameter, this.expression);

  @override
  String invoke(Context context, String name, String value) {
    return expression.replaceAll('{{$parameter}}', value);
  }
}

class FuncExprTransformer<I, O> extends Transformer<I, O> {
  final String expression;

  final String parameter;

  const FuncExprTransformer(this.parameter, this.expression);

  @override
  String declare(Context context, String name) {
    return '$O $name($I $parameter) => $expression;';
  }

  @override
  String invoke(Context context, String name, String value) {
    return '$name($value)';
  }
}

class FuncTransformer<I, O> extends Transformer<I, O> {
  final String body;

  final String parameter;

  const FuncTransformer(this.parameter, this.body);

  @override
  String declare(Context context, String name) {
    return '$O $name($I $parameter) { $body }';
  }

  @override
  String invoke(Context context, String name, String value) {
    return '$name($value)';
  }
}

abstract class Transformer<I, O> {
  const Transformer();

  String declare(Context context, String name) {
    return '';
  }

  String invoke(Context context, String name, String value);
}

class VarTransformer<I, O> extends Transformer<I, O> {
  final String expression;

  const VarTransformer(this.expression);

  @override
  String declare(Context context, String name) {
    return 'final $name = $expression;';
  }

  @override
  String invoke(Context context, String name, String value) {
    return name;
  }
}
