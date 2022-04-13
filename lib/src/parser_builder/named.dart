part of '../../parser_builder.dart';

class Named<I, O> extends ParserBuilder<I, O> {
  final List<String> annotaions;

  final String name;

  final ParserBuilder<I, O> parser;

  const Named(this.name, this.parser, [this.annotaions = const []]);

  @override
  BuidlResult build(
      Context context, CodeGen code, ParserResult result, bool silent) {
    final key = BuidlResult();
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

    return key;
  }

  @override
  bool isAlwaysSuccess() {
    return parser.isAlwaysSuccess();
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
    final result = helper.getResult(context, code, parser, fast);
    helper.build(context, code, parser, result, silent);
    final codeOptimizer = CodeOptimizer();
    codeOptimizer.optimize(statements);
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

    if (!result.isVoid) {
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
