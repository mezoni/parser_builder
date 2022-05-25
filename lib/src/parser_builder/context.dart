part of '../../parser_builder.dart';

class Context {
  final Map<String, String> classDeclarations = {};

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

  Map<String, SemanticValue> semanticValues = {};

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

  SemanticValue allocateSematicValue<T>(String name) {
    if (semanticValues.containsKey(name)) {
      throw ArgumentError.value(name, 'name', 'Semantic value already exists');
    }

    while (true) {
      final alias = localAllocator.allocate(name);
      if (!localDeclarations.containsKey(alias)) {
        final value = SemanticValue<T>(alias);
        final type = helper.asNullable<T>();
        semanticValues[name] = value;
        localDeclarations[alias] = '$type $alias;';
        return value;
      }
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

  String renderSemanticValues(String template) {
    var result = template;
    for (final key in semanticValues.keys) {
      final value = semanticValues[key]!;
      result = result.replaceAll('{{$key}}', value.name);
      result = result.replaceAll('{{$key|value}}', value.value);
      result = result.replaceAll('{{$key|safe_value}}', value.safeValue);
    }

    return result;
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
