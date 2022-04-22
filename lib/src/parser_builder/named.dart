part of '../../parser_builder.dart';

class Named<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{res0}} = {{name}}(state);''';

  static const _templateFast = '''
{{name}}(state);''';

  final List<String> annotaions;

  final String name;

  final ParserBuilder<I, O> parser;

  const Named(this.name, this.parser, [this.annotaions = const []]);

  @override
  String build(Context context, ParserResult? result) {
    if (!context.context.containsKey(this)) {
      context.context[this] = null;
      _buildDeclaration(context);
    }

    final fast = result == null;
    final values = {
      'name': name,
    };
    return render2(fast, _templateFast, _template, values, [result]);
  }

  void _buildDeclaration(Context context) {
    final localAllocator = context.localAllocator;
    final localDeclarations = context.localDeclarations;
    final refersToStateSource = context.refersToStateSource;
    context.localAllocator = localAllocator.clone();
    context.localDeclarations = {};
    context.refersToStateSource = false;
    final result = context.getResult(parser, true)!;
    final code = parser.build(context, result);
    final buffer = StringBuffer();
    if (annotaions.isNotEmpty) {
      buffer.writeln(annotaions.join('\n'));
    }

    buffer.write(result.type);
    buffer.write(' ');
    buffer.write(name);
    buffer.write('(State<');
    buffer.write(I);
    buffer.writeln('> state) {');
    if (result.type != 'void') {
      buffer.write(result.type);
      buffer.write(' ');
      buffer.write(result.name);
      buffer.write(';');
    }
    if (context.refersToStateSource) {
      buffer.writeln('final source = state.source;');
    }
    for (final declaration in context.localDeclarations.values) {
      buffer.writeln(declaration);
    }

    buffer.writeln(code);
    if (result.type != 'void') {
      buffer.write('return ');
      buffer.write(result.name);
      buffer.write(';');
    }

    buffer.writeln('}');
    context.refersToStateSource = refersToStateSource;
    context.localDeclarations = localDeclarations;
    context.localAllocator = localAllocator;
    final globalDeclarations = context.globalDeclarations;
    globalDeclarations.add(buffer.toString());
  }
}
