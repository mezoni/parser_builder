part of '../../parser_builder.dart';

class Context {
  final List<String> declarations = [];

  final Set<Object> keys = {};

  Allocator localAllocator = Allocator('\$');

  String? Function(ParserBuilder builder)? onEnter;

  String? Function(ParserBuilder builder, String resultVariable)? onLeave;

  bool optimizeForSize = true;

  String resultVariable = '';

  bool refersToSourceVariable = false;

  String allocateLocal([String name = '']) {
    final result = localAllocator.allocate(name);
    return result;
  }

  Map<String, String> allocateLocals(List<String> names) {
    final result = <String, String>{};
    for (final name in names) {
      result[name] = allocateLocal(name);
    }

    return result;
  }
}
