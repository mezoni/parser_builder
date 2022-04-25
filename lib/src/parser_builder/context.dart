part of '../../parser_builder.dart';

class Context {
  final Map<Object, Object?> context = {};

  final List<String> globalDeclarations = [];

  Allocator globalAllocator = Allocator('_\$');

  Map<String, String> localDeclarations = {};

  Allocator localAllocator = Allocator('\$');

  bool optimizeFastParsers = true;

  int pass = 0;

  bool refersToStateSource = false;

  final Map<dynamic, Map<String, dynamic>> _registry = {};

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

  T getRegistry<T>(owner, String name, T defaultValue) {
    var registry = _registry[owner];
    if (registry == null) {
      registry = <String, T>{};
      _registry[owner] = registry;
    }

    if (!registry.containsKey(name)) {
      registry[name] = defaultValue;
      return defaultValue;
    } else {
      return registry[name] as T;
    }
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
