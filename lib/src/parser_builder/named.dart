part of '../../parser_builder.dart';

class Named<I, O> extends ParserBuilder<I, O> {
  final List<String> annotaions;

  final String name;

  final ParserBuilder<I, O> parser;

  const Named(this.name, this.parser, [this.annotaions = const []]);

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    if (!context.context.containsKey(this)) {
      context.context[this] = null;
      _buildDeclaration(context, silent);
    }

    final fast = result.isVoid;
    if (fast) {
      code + '$name(state);';
    } else {
      code.setResult(result, '$name(state)', false);
    }
  }

  void _buildDeclaration(Context context, bool silent) {
    final localAllocator = context.localAllocator;
    final localDeclarations = context.localDeclarations;
    final refersToStateSource = context.refersToStateSource;
    context.localAllocator = localAllocator.clone();
    context.localDeclarations = {};
    context.refersToStateSource = false;
    final statements = LinkedList<Statement>();
    final code = CodeGen(statements);
    final fast = parser.getResultType() == 'void';
    final r1 = helper.build(context, code, parser, silent, fast);
    final codeOptimizer = CodeOptimizer();
    codeOptimizer.optimize(statements);
    final buffer = StringBuffer();
    if (annotaions.isNotEmpty) {
      buffer.writeln(annotaions.join('\n'));
    }

    buffer.write(r1.type);
    buffer.write(' ');
    buffer.write(name);
    buffer.write('(State<');
    buffer.write(I);
    buffer.writeln('> state) {');
    if (context.refersToStateSource) {
      buffer.writeln('final source = state.source;');
    }
    for (final declaration in context.localDeclarations.values) {
      buffer.writeln(declaration);
    }

    final printer = Printer();
    for (final statement in statements) {
      printer.print(statement, buffer);
      buffer.writeln();
    }

    if (!r1.isVoid) {
      buffer.write('return ');
      buffer.write(r1.name);
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
