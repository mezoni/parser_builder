import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:test/test.dart';
import 'package:parser_builder/src/char_class/binary_search_builder.dart';

void main() async {
  test('Test binary search builder', () async {
    final count = 100;
    for (final negate in [false, true]) {
      for (var i = 1; i < count; i++) {
        final pattern = <int>[];
        for (var k = 0; k < i; k++) {
          final value = (k + 1) * 10;
          pattern.add(value - 5);
          pattern.add(value);
        }

        final testData = List.generate(pattern.length + 1, (i) => i);
        final builder = BinarySearchBuilder();
        final code = builder.build('i', pattern, negate);
        var contents = _template;
        contents = contents.replaceAll('{{code}}', code);
        final directory = Directory.current;
        final relative = 'test/_test_test_binary_search_builder.dart';
        final path = directory.path + '/' + relative;
        final uri = Uri.file(path);
        File(relative).writeAsStringSync(contents);
        final response = ReceivePort();
        final remote = await Isolate.spawnUri(uri, ["foo"], response.sendPort);
        SendPort? port;
        response.listen((message) {
          if (port == null) {
            port = message as SendPort;
            port!.send(testData);
          } else {
            final ranges = <Range>[];
            for (var i = 0; i < pattern.length; i += 2) {
              final start = pattern[i];
              final end = pattern[i + 1];
              final range = Range(start, end);
              ranges.add(range);
            }

            final results = message as List<bool>;
            for (var i = 0; i < results.length; i++) {
              final result = results[i];
              var found =
                  ranges.where((e) => i >= e.start && i <= e.end).isEmpty;
              final matcher = negate ? found : !found;
              expect(result, matcher, reason: '''
Tsst data: ${testData.join(', ')}
Failed: $i
Negate: $negate
Code: $code
''');
            }

            Timer(Duration(milliseconds: 500), () {
              remote.kill(priority: Isolate.immediate);
            });
          }
        });
      }
    }
  });
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
