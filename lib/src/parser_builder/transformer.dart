part of '../../parser_builder.dart';

abstract class CharPredicate {
  bool get has32BitChars;
}

class ClosureTransformer<T> extends Transformer<T> {
  final String expression;

  final List<String> parameters;

  const ClosureTransformer(this.parameters, this.expression);

  @override
  String declare(Transformation transformation) {
    final name = transformation.name;
    return 'final $name = $expression;';
  }

  @override
  String invoke(Transformation transformation) {
    final arguments = transformation.checkArguments(parameters);
    final name = transformation.name;
    return '$name($arguments)';
  }
}

class ExprTransformer<T> extends Transformer<T> {
  final String expression;

  final List<String> parameters;

  const ExprTransformer(this.parameters, this.expression);

  const ExprTransformer.value(this.expression) : parameters = const [];

  @override
  String invoke(Transformation transformation) {
    return transformation.replaceParameters(expression, parameters);
  }
}

class FuncExprTransformer<T> extends Transformer<T> {
  final String expression;

  final List<String> parameters;

  const FuncExprTransformer(this.parameters, this.expression);

  @override
  String declare(Transformation transformation) {
    final name = transformation.name;
    final params = parameters.join(', ');
    return '$T $name($params) => $expression;';
  }

  @override
  String invoke(Transformation transformation) {
    final arguments = transformation.checkArguments(parameters);
    final name = transformation.name;
    return '$name($arguments)';
  }
}

class FuncTransformer<T> extends Transformer<T> {
  final String body;

  final List<String> parameters;

  const FuncTransformer(this.parameters, this.body);

  @override
  String declare(Transformation transformation) {
    final name = transformation.name;
    final params = parameters.join(', ');
    return '$T $name($params) { $body }';
  }

  @override
  String invoke(Transformation transformation) {
    final arguments = transformation.checkArguments(parameters);
    final name = transformation.name;
    return '$name($arguments)';
  }
}

class Transformation {
  final List<String> arguments;

  final Context context;

  final String name;

  final Map<String, dynamic> state = {};

  Transformation(
      {required this.context, required this.name, required this.arguments});

  String checkArguments(List<String> parameters) {
    final length = parameters.length;
    if (arguments.length != length) {
      throw ArgumentError.value(arguments.toString(), 'arguments',
          'List of arguments must contain $length elements to pass parameters \'${parameters.join(', ')}\'');
    }

    return arguments.join(', ');
  }

  String replaceParameters(String template, List<String> parameters) {
    checkArguments(parameters);
    for (var i = 0; i < parameters.length; i++) {
      final argument = arguments[i];
      final parameter = parameters[i];
      template = template.replaceAll('{{$parameter}}', argument);
    }

    return template;
  }
}

abstract class Transformer<T> {
  const Transformer();

  String declare(Transformation transformation) {
    return '';
  }

  String invoke(Transformation transformation);
}

class VarTransformer<T> extends Transformer<T> {
  final String expression;

  const VarTransformer(this.expression);

  @override
  String declare(Transformation transformation) {
    final name = transformation.name;
    return 'final $name = $expression;';
  }

  @override
  String invoke(Transformation transformation) {
    final name = transformation.name;
    return name;
  }
}
