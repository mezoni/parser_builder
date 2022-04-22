part of '../../parser_builder.dart';

class Context {
  final Map<Object, Object?> context = {};

  final List<String> globalDeclarations = [];

  Allocator globalAllocator = Allocator('_\$');

  Map<String, String> localDeclarations = {};

  Allocator localAllocator = Allocator('\$');

  bool refersToStateSource = false;

  String allocateGlobal([String name = '']) {
    final result = globalAllocator.allocate(name);
    return result;
  }

  String allocateLocal([String name = '']) {
    final result = localAllocator.allocate(name);
    return result;
  }

  Map<String, String> allocateLocals(Iterable names) {
    final result = <String, String>{};
    for (final name in names) {
      result[name] = allocateLocal(name);
    }

    return result;
  }

  ParserResult? getResult(ParserBuilder parser, bool condition) {
    if (!condition) {
      return null;
    }

    final name = allocateLocal();
    final type = parser.getResultType();
    final value = parser.getResultValue(name);
    return ParserResult(name, type, value);
  }
}
