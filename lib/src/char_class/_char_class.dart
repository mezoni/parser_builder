part of '../../char_class.dart';

abstract class _CharClass extends SemanticAction<bool> {
  final bool negate;

  const _CharClass({required this.negate});

  @override
  bool get isUnicode {
    if (negate) {
      return true;
    }

    final list = getCharList();
    return list.any((e) => e > 0xffff);
  }

  @override
  String build(Context context, String name, List<String> arguments) {
    checkArguments(['c'], arguments, getChars());
    final builder = BinarySearchBuilder();
    final argument = arguments.first;
    final list = getCharList();
    final result = builder.build(argument, list, negate);
    return result;
  }

  List<int> getCharList() {
    final chars = getChars();
    final parser = RangesParser();
    final result = parser.parse(chars);
    return result;
  }

  String getChars();

  static String listToPattern(List<int> chars) {
    if (chars.isEmpty) {
      throw ArgumentError('List of chars mus not be empty');
    }

    final list = <String>[];
    for (var i = 0; i < chars.length; i++) {
      final c = chars[i];
      if (!(c >= 0 && c <= 0xd7ff || c >= 0xe000 && c <= 0x10ffff)) {
        throw RangeError.value(c, 'c', 'Must be a valid Unicode code point');
      }

      final hex = c.toRadixString(16);
      final value = '#x$hex';
      list.add(value);
    }

    return list.join(' | ');
  }
}
