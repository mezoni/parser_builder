part of '../../parser_builder.dart';

class Allocator {
  final Map<String, int> _names = {};

  final String prefix;

  Allocator(this.prefix);

  String allocate([String name = '']) {
    var id = _names[name];
    id ??= 0;
    var result = '';
    if (name.isNotEmpty && id == 0) {
      result = '$prefix$name';
    } else {
      result = '$prefix$name$id';
    }

    _names[name] = id + 1;
    return result;
  }

  Allocator clone() {
    return Allocator(prefix);
  }
}
