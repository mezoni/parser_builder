part of '../../parser_builder.dart';

class Context {
  final Map<Object, Object?> context = {};

  bool diagnose = false;

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
}
