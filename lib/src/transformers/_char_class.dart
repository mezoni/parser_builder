part of '../../transformers.dart';

abstract class _CharClass extends TX<int, bool> {
  static const _templateBinarySearch = '''
{
  const list = [{{values}}];
  var l = 0;
  var r = {{r}};
  while (l <= r) {
    final m = (l + r) ~/ 2;
    final i = m << 1;
    final s = list[i];
    final e = list[i + 1];
    if ({{c}} >= s && {{c}} <= e) {
      return true;
    } else if (c <= s) {
      r = m - 1;
    } else {
      l = m + 1;
    }
  }
  return false;
}''';

  final RangeProcessing processing;

  const _CharClass({this.processing = RangeProcessing.test}) : super('c');

  String getChars();

  @override
  String getCode() {
    final chars = getChars();
    final parser = RangesParser();
    final list = parser.parse(chars);
    String toHex(int value) {
      return '0x${value.toRadixString(16).toUpperCase()}';
    }

    switch (processing) {
      case RangeProcessing.test:
        final tests = <String>[];
        for (var i = 0; i < list.length; i += 2) {
          final start = list[i];
          final end = list[i + 1];
          if (start == end) {
            tests.add('$parameter == ${toHex(start)}');
          } else {
            tests.add(
                '$parameter >= ${toHex(start)} && $parameter <= ${toHex(end)}');
          }
        }

        final result = tests.join(' || ');
        return '=> $result;';
      case RangeProcessing.search:
        var result = _templateBinarySearch;
        result = result.replaceAll('{{c}}', parameter);
        result =
            result.replaceAll('{{r}}', ((list.length >> 1) - 1).toString());
        result = result.replaceAll('{{values}}', list.join(', '));
        return result;
    }
  }
}
