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
    final arguments = transformation.checkArguments(parameters, expression);
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
    final arguments = transformation.checkArguments(parameters, expression);
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
    final arguments = transformation.checkArguments(parameters, body);
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

  String checkArguments(List<String> parameters, String information) {
    if (arguments.length != parameters.length) {
      throw ArgumentError(
          'The list of arguments [${arguments.join(', ')}] does not match the number of parameters [${parameters.join(', ')}]: $information');
    }

    return arguments.join(', ');
  }

  String replaceParameters(String template, List<String> parameters) {
    checkArguments(parameters, template);
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

  final String init;

  final String key;

  final List<String> parameters;

  const VarTransformer(this.parameters, this.expression,
      {required this.init, required this.key});

  @override
  String declare(Transformation transformation) {
    final name = transformation.name;
    return 'final $name = $init;';
  }

  @override
  String invoke(Transformation transformation) {
    transformation.checkArguments(parameters, expression);
    final name = transformation.name;
    var result = transformation.replaceParameters(expression, parameters);
    result = result.replaceAll('{{$key}}', name);
    return result;
  }
}
