part of '../../transformers.dart';

abstract class _CharClass extends Transformer<int, bool>
    implements CharPredicate {
  static const _templateBinarySearch = '''
bool {{name}}(int c) {
  const list = [{{values}}];
  var l = 0;
  var r = {{r}};
  while (l <= r) {
    final m = (l + r) ~/ 2;
    final i = m << 1;
    final s = list[i];
    final e = list[i + 1];
    if (c >= s && c <= e) {
      return true;
    } else if (c <= s) {
      r = m - 1;
    } else {
      l = m + 1;
    }
  }
  return false;
}''';

  final bool negate;

  final RangeProcessing processing;

  const _CharClass(
      {required this.negate, this.processing = RangeProcessing.test});

  @override
  bool get canInline => true;

  @override
  bool get has32BitChars {
    if (negate) {
      return true;
    }
    final list = getCharList();
    return list.any((e) => e > 0xffff);
  }

  @override
  String declare(String name) {
    switch (processing) {
      case RangeProcessing.search:
        final list = getCharList();
        var result = _templateBinarySearch;
        result = result.replaceAll('{{name}}', name);
        result =
            result.replaceAll('{{r}}', ((list.length >> 1) - 1).toString());
        result = result.replaceAll('{{values}}', list.join(', '));
        return result;
      case RangeProcessing.test:
        final expr = inline('c');
        return 'bool $name(int c) => $expr;';
    }
  }

  List<int> getCharList() {
    final chars = getChars();
    final parser = RangesParser();
    final result = parser.parse(chars);
    return result;
  }

  String getChars();

  @override
  String inline(String argument) {
    final list = getCharList();
    final tests = <String>[];
    for (var i = 0; i < list.length; i += 2) {
      final start = list[i];
      final end = list[i + 1];
      if (start == end) {
        tests.add('$argument == $start');
      } else {
        tests.add('$argument >= $start && $argument <= $end');
      }
    }

    var result = tests.join(' || ');
    return negate ? '!($result)' : result;
  }

  @override
  String invoke(String name, String argument) {
    return '$name($argument)';
  }
}
