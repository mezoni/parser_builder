part of '../../parser_builder.dart';

class Context {
  final List<String> globalDeclarations = [];

  Allocator globalAllocator = Allocator('_\$');

  Map<dynamic, Map<String, dynamic>> globalRegistry = {};

  Map<String, String> localDeclarations = {};

  Allocator localAllocator = Allocator('\$');

  Map<dynamic, Map<String, dynamic>> localRegistry = {};

  bool optimizeFastParsers = true;

  int pass = 0;

  final Map<dynamic, Map<String, dynamic>> registry = {};

  bool refersToStateSource = false;

  String allocateGlobal([String name = '']) {
    final result = globalAllocator.allocate(name);
    return result;
  }

  String allocateLocal([String name = '']) {
    final result = localAllocator.allocate(name);
    return result;
  }

  Map<String, String> allocateLocals(Iterable<String> names) {
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

  T readRegistryValue<T>(Map<dynamic, Map<String, dynamic>> registry, owner,
      String key, T Function() defaultValue) {
    final section = _getRegistrySection(registry, owner);
    if (!section.containsKey(key)) {
      final value = defaultValue();
      section[key] = value;
      return value;
    } else {
      return section[key] as T;
    }
  }

  void writeRegistryValue<T>(
      Map<dynamic, Map<String, dynamic>> registry, owner, String key, T value) {
    final section = _getRegistrySection(registry, owner);
    section[key] = value;
  }

  Map<String, dynamic> _getRegistrySection(
      Map<dynamic, Map<String, dynamic>> registry, owner) {
    var result = registry[owner];
    if (result == null) {
      result = <String, dynamic>{};
      registry[owner] = result;
    }

    return result;
  }
}
