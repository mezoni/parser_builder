part of '../../parser_builder.dart';

class ClosureAction<T> extends SemanticAction<T> {
  final String expression;

  final List<String> parameters;

  const ClosureAction(this.parameters, this.expression);

  @override
  String build(Context context, String name, List<String> arguments) {
    name = context.allocateLocal(name);
    final declaration = 'final $name = $expression;';
    addLocalDeclaration(context, name, declaration);
    final args = checkArguments(parameters, arguments, expression);
    return '$name($args)';
  }
}

class ExprAction<T> extends SemanticAction<T> {
  final String expression;

  final List<String> parameters;

  const ExprAction(this.parameters, this.expression);

  const ExprAction.value(this.expression) : parameters = const [];

  @override
  String build(Context context, String name, List<String> arguments) {
    return replaceParameters(expression, parameters, arguments);
  }
}

class FuncAction<T> extends SemanticAction<T> {
  final String body;

  final List<String> parameters;

  const FuncAction(this.parameters, this.body);

  @override
  String build(Context context, String name, List<String> arguments) {
    name = context.allocateLocal(name);
    final declaration = '$T $name(${parameters.join(' ,')}) { $body }';
    addLocalDeclaration(context, name, declaration);
    final args = checkArguments(parameters, arguments, body);
    return '$name($args)';
  }
}

class FuncExprAction<T> extends SemanticAction<T> {
  final String expression;

  final List<String> parameters;

  const FuncExprAction(this.parameters, this.expression);

  @override
  String build(Context context, String name, List<String> arguments) {
    name = context.allocateLocal(name);
    final declaration = '$T $name(${parameters.join(', ')}) => $expression;';
    addLocalDeclaration(context, name, declaration);
    final args = checkArguments(parameters, arguments, expression);
    return '$name($args)';
  }
}

abstract class SemanticAction<T> {
  const SemanticAction();

  bool get isUnicode {
    return true;
  }

  void addLocalDeclaration(Context context, String name, String declaration) {
    final declarations = context.localDeclarations;
    if (declarations.containsKey(name)) {
      throw StateError("Local declaration $name already exist");
    }

    declarations[name] = declaration;
  }

  String build(Context context, String name, List<String> arguments);

  String checkArguments(
      List<String> parameters, List<String> arguments, String information) {
    if (arguments.length != parameters.length) {
      throw ArgumentError(
          'The list of arguments [${arguments.join(', ')}] does not match the number of parameters [${parameters.join(', ')}]: $information');
    }

    return arguments.join(', ');
  }

  String replaceParameters(
      String template, List<String> parameters, List<String> arguments) {
    checkArguments(parameters, arguments, template);
    for (var i = 0; i < parameters.length; i++) {
      final argument = arguments[i];
      final parameter = parameters[i];
      template = template.replaceAll('{{$parameter}}', argument);
    }

    return template;
  }
}

class VarAction<T> extends SemanticAction<T> {
  final String expression;

  final String init;

  final String key;

  final List<String> parameters;

  const VarAction(this.parameters, this.expression,
      {required this.init, required this.key});

  @override
  String build(Context context, String name, List<String> arguments) {
    name = context.allocateLocal(name);
    final declaration = 'final $name = $init;';
    addLocalDeclaration(context, name, declaration);
    var result = replaceParameters(expression, parameters, arguments);
    result = result.replaceAll('{{$key}}', name);
    return result;
  }
}
