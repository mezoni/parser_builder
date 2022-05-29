import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:parser_builder/src/char_class/binary_search_builder.dart';
import 'package:test/test.dart';

void main() async {
  final count = 250;
  final generators = [
    _generateComplexNotStartighWithZero,
    _generateComplexStartingWithZero,
    _generateSimpleStartingWithZero,
    _generateNotSimpleStartingWithZero,
  ];
  for (final negate in [false, true]) {
    for (var generator in generators) {
      test('Test binary builder', () async {
        for (var i = 1; i < count; i++) {
          final pattern = generator(i);
          final testData = List.generate(pattern.last + 1, (i) => i);
          final builder = BinarySearchBuilder();
          final code = builder.build('i', pattern, negate);
          var contents = _template;
          contents = contents.replaceAll('{{code}}', code);
          final directory = Directory.current;
          final relative = 'test/_test_test_binary_search_builder.dart';
          final path = '${directory.path}/$relative';
          final uri = Uri.file(path);
          File(relative).writeAsStringSync(contents);
          final response = ReceivePort();
          final remote =
              await Isolate.spawnUri(uri, ["foo"], response.sendPort);
          SendPort? port;
          response.listen((message) {
            if (port == null) {
              port = message as SendPort;
              port!.send(testData);
            } else {
              final ranges = <_Range>[];
              for (var i = 0; i < pattern.length; i += 2) {
                final start = pattern[i];
                final end = pattern[i + 1];
                final range = _Range(start, end);
                ranges.add(range);
              }

              final results = message as List<bool>;
              for (var i = 0; i < results.length; i++) {
                final result = results[i];
                final found =
                    ranges.where((e) => i >= e.start && i <= e.end).isEmpty;
                final matcher = negate ? found : !found;
                expect(result, matcher, reason: '''
Failed: $i
Negate: $negate
Generator: $generator
Code: $code
''');
              }

              Timer(Duration(milliseconds: 500), () {
                response.close();
                remote.kill(priority: Isolate.immediate);
              });
            }
          });
        }
      }, timeout: Timeout(Duration(minutes: 2)));
    }
  }
}

const _template = '''
import 'dart:isolate';

void main(List<String> args, SendPort replyTo) async {
  final receivePort = ReceivePort();
  final port = receivePort.sendPort;
  replyTo.send(port);
  receivePort.listen((message) {
    final list = message as List<int>;
    final results = <bool>[];
    for (var i = 0; i < list.length; i++) {
      final result = {{code}};
      results.add(result);
    }

    replyTo.send(results);
  });
}
''';

List<int> _generateComplexNotStartighWithZero(int n) {
  final result = <int>[];
  for (var i = 0; i < n; i++) {
    final value = (i + 1) * 10;
    result.add(value - 5);
    result.add(value);
  }

  return result;
}

List<int> _generateComplexStartingWithZero(int n) {
  final result = <int>[];
  for (var i = 0; i < n; i++) {
    final value = i * 10 + 5;
    result.add(value - 5);
    result.add(value);
  }

  return result;
}

List<int> _generateNotSimpleStartingWithZero(int n) {
  final result = <int>[];
  for (var i = 0; i < n; i++) {
    final value = i * 10 + 1;
    result.add(value);
    result.add(value);
  }

  return result;
}

List<int> _generateSimpleStartingWithZero(int n) {
  final result = <int>[];
  for (var i = 0; i < n; i++) {
    final value = i * 10;
    result.add(value);
    result.add(value);
  }

  return result;
}

class _Range {
  final int end;

  final int start;

  _Range(this.start, this.end) {
    if (start < 0) {
      throw ArgumentError.value(
          start, 'start', 'Must be greater then ot equal to 0');
    }

    if (end < start) {
      throw ArgumentError.value(
          end, 'end', 'Must be greater then ot equal to $start');
    }
  }

  @override
  String toString() {
    return '$start..$end';
  }
}
