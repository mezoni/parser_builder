import 'package:test/test.dart';

import '_parse_number.dart';

void main(List<String> args) {
  _test();
}

void _test() {
  test('ParseNumber', () {
    _testResult('-', null);
    _testResult('-0', 0);
    _testResult('-00', null);
    _testResult('00', null);

    var i = 0;
    _testResult(i.toString(), i);
    i = 9223372036854775807;
    while (true) {
      _testResult(i.toString(), i);
      i ~/= 2;
      if (i == 0) {
        break;
      }
    }

    i = -9223372036854775807;
    while (true) {
      _testResult(i.toString(), i);
      i ~/= 2;
      if (i == 0) {
        break;
      }
    }

    var f = 0.0;
    _testResult(f.toString(), f);
    f = -0.0;
    _testResult(f.toString(), f);
    f = double.maxFinite;
    _testResult(f.toString(), f);
    f = double.minPositive;
    _testResult(f.toString(), f);

    f = 9007199254740992.0;
    while (true) {
      _testResult(f.toString(), f);
      f /= 2;
      if (f < 1) {
        break;
      }
    }

    f = -9007199254740992.0;
    while (true) {
      _testResult(f.toString(), f);
      f /= 2;
      if (f > -1.0) {
        break;
      }
    }

    _testResult('1e0', 1e0);
    _testResult('1e2', 1e2);
    _testResult('1e4', 1e4);
    _testResult('1e8', 1e8);
    _testResult('1e16', 1e16);
    _testResult('1e32', 1e32);
    _testResult('1e64', 1e64);
    _testResult('1e128', 1e128);
    _testResult('1e256', 1e256);

    _testResult('1e-0', 1e-0);
    _testResult('1e-2', 1e-2);
    _testResult('1e-4', 1e-4);
    _testResult('1e-8', 1e-8);
    _testResult('1e-16', 1e-16);
    _testResult('1e-32', 1e-32);
    _testResult('1.01e-32', 1.01e-32);
    _testResult('1e-64', 1e-64);
    _testResult('1e-128', 1e-128);
    _testResult('1e-256', 1e-256);

    _testResult('-1e0', -1e0);
    _testResult('-1e2', -1e2);
    _testResult('-1e4', -1e4);
    _testResult('-1e8', -1e8);
    _testResult('-1e16', -1e16);
    _testResult('-1e32', -1e32);
    _testResult('-1e64', -1e64);
    _testResult('-1e128', -1e128);
    _testResult('-1e256', -1e256);

    _testResult('-1e-0', -1e-0);
    _testResult('-1e-2', -1e-2);
    _testResult('-1e-4', -1e-4);
    _testResult('-1e-8', -1e-8);
    _testResult('-1e-16', -1e-16);
    _testResult('-1e-32', -1e-32);
    _testResult('-1e-64', -1e-64);
    _testResult('-1e-128', -1e-128);
    _testResult('-1e-256', -1e-256);
  });
}

void _testResult(String s, num? v) {
  final result = parseNumber(s, 0);
  final x = result.item2;
  expect(x, v);
}
