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
      context.context[this] = {};
      var fast = false;
      if (context.pass != 0) {
        if (context.optimizeFastParsers) {
          final modes = _getParserModes(context);
          if (modes.length == 1) {
            fast = modes.first;
          }
        }
      }

      _buildDeclaration(context, fast);
    }

    final fast = result == null;
    _registerParserMode(context, fast);
    final values = {
      'name': name,
    };
    return render2(fast, _templateFast, _template, values, [result]);
  }

  void _buildDeclaration(Context context, bool fast) {
    final localAllocator = context.localAllocator;
    final localDeclarations = context.localDeclarations;
    final refersToStateSource = context.refersToStateSource;
    context.localAllocator = localAllocator.clone();
    context.localDeclarations = {};
    context.refersToStateSource = false;
    final result = context.getResult(parser, !fast);
    final code = parser.build(context, result);
    final buffer = StringBuffer();
    if (annotaions.isNotEmpty) {
      buffer.writeln(annotaions.join('\n'));
    }

    final type = result == null ? 'void' : result.type;
    buffer.write(type);
    buffer.write(' ');
    buffer.write(name);
    buffer.write('(State<');
    buffer.write(I);
    buffer.writeln('> state) {');
    if (result != null && result.type != 'void') {
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
    if (result != null && result.type != 'void') {
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

  Set<bool> _getParserModes(Context context) {
    final registry = _getParserModesRegistry(context);
    var result = registry[parser];
    if (result == null) {
      result = {};
      registry[this] = result;
    }

    return result;
  }

  Map<Named, Set<bool>> _getParserModesRegistry(Context context) {
    var result = context.context[Named] as Map<Named, Set<bool>>?;
    if (result == null) {
      result = {};
      context.context[Named] = result;
    }

    return result;
  }

  void _registerParserMode(Context context, bool fast) {
    var modes = _getParserModes(context);
    modes.add(fast);
  }
}
