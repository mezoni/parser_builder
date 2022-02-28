part of '../../parser_builder.dart';

class Named<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{res}} = {{name}}(state);''';

  static const _templateDeclaration = '''
{{type}} {{name}}(State<{{I}}> state) {
  {{body}}
  return {{res}};
}''';

  final List<String> annotaions;

  final String name;

  final ParserBuilder<I, O> parser;

  const Named(this.name, this.parser, [this.annotaions = const []]);

  @override
  String build(Context context) {
    if (context.keys.add(this)) {
      _buildDeclaration(context);
    }

    return super.build(context);
  }

  @override
  Map<String, String> getTags(Context context) {
    return {
      'name': name,
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([name, parser]);
  }

  String _buildDeclaration(Context context) {
    final localAllocator = context.localAllocator;
    final resultVariable = context.resultVariable;
    final refersToSourceVariable = context.refersToSourceVariable;
    context.localAllocator = localAllocator.clone();
    context.resultVariable = context.allocateLocal();
    context.refersToSourceVariable = false;
    var code = parser.buildAndAssign(context, context.resultVariable);
    if (context.refersToSourceVariable) {
      code = 'final source = state.source;\n' + code.trim();
    }

    final values = {
      'body': code,
      'I': '$I',
      'name': name,
      'O': '$O',
      'res': context.resultVariable,
      'type': getResultType(),
    };
    var result = render(_templateDeclaration, values);
    if (annotaions.isNotEmpty) {
      final code = annotaions.join('\n');
      result = code + result;
    }

    context.declarations.add(result);
    context.localAllocator = localAllocator;
    context.resultVariable = resultVariable;
    context.refersToSourceVariable = refersToSourceVariable;
    return result;
  }
}
