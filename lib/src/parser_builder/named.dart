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
    final fast = result == null;
    if (context.pass == 0) {
      _registerParserMode(context, fast);
      final processed = _getProcessed(context);
      if (processed.add(this)) {
        _buildDeclaration(context, fast);
      }
    } else {
      final processed = _getProcessed(context);
      if (processed.add(this)) {
        final modes = _getParserModes(context);
        var newFast = false;
        if (modes.length == 1) {
          newFast = modes.first;
        }

        _buildDeclaration(context, newFast);
      }
    }

    final values = {
      'name': name,
    };
    return render2(fast, _templateFast, _template, values, [result]);
  }

  @override
  String toString() {
    return name;
  }

  void _buildDeclaration(Context context, bool fast) {
    final localAllocator = context.localAllocator;
    final localDeclarations = context.localDeclarations;
    final localRegistry = context.localRegistry;
    final refersToStateSource = context.refersToStateSource;
    final semanticValues = context.capturedValues;
    context.localAllocator = localAllocator.clone();
    context.localDeclarations = {};
    context.localRegistry = {};
    context.refersToStateSource = false;
    context.capturedValues = {};
    if (parser.getResultType() == 'void') {
      fast = true;
    }

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
    context.capturedValues = semanticValues;
    context.refersToStateSource = refersToStateSource;
    context.localDeclarations = localDeclarations;
    context.localRegistry = localRegistry;
    context.localAllocator = localAllocator;
    final globalDeclarations = context.globalDeclarations;
    globalDeclarations.add(buffer.toString());
  }

  Set<bool> _getParserModes(Context context) {
    final result = context.readRegistryValue(
        context.registry, this, 'modes', () => <bool>{});
    return result;
  }

  Set<Named> _getProcessed(Context context) {
    final result = context.readRegistryValue(
        context.globalRegistry, this, 'processed', () => <Named>{});
    return result;
  }

  void _registerParserMode(Context context, bool fast) {
    final modes = _getParserModes(context);
    modes.add(fast);
  }
}
