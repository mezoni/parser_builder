import 'package:test/test.dart';

import 'package:parser_builder/src/transformers/char_class_parser.dart';

import 'package:tuple/tuple.dart';

void main(List<String> args) {
  _test();
}

void _test() {
  test('CharClassParser', () {
    final parser = parse;
    {
      final state = State(' "1" ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [Tuple2(0x31, 0x31)]);
    }
    {
      final state = State(' #x31 ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [Tuple2(0x31, 0x31)]);
    }
    {
      final state = State(' [A-Z] ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [Tuple2(0x41, 0x5a)]);
    }
    {
      final state = State(' [#x20-#x7f] ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [Tuple2(0x20, 0x7f)]);
    }
    {
      final state = State(' [#x10000-#x10200] ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [Tuple2(0x10000, 0x10200)]);
    }
    {
      final state = State(' "1" | [A-Z] ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [Tuple2(0x31, 0x31), Tuple2(0x41, 0x5a)]);
    }
    {
      final state = State(' "1" | [A-Z] | [#x20-#x7f] | [#x10000-#x10200] ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [
        Tuple2(0x31, 0x31),
        Tuple2(0x41, 0x5a),
        Tuple2(0x20, 0x7f),
        Tuple2(0x10000, 0x10200)
      ]);
    }
    {
      final state = State(' [1A-Z#x20-#x7f#x10000-#x10200+,-] ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [
        Tuple2(0x31, 0x31),
        Tuple2(0x41, 0x5a),
        Tuple2(0x20, 0x7f),
        Tuple2(0x10000, 0x10200),
        Tuple2(0x2b, 0x2b),
        Tuple2(0x2c, 0x2c),
        Tuple2(0x2d, 0x2d)
      ]);
    }
    {
      final state = State(r' [A-Za-z0-9_] | "$" ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [
        Tuple2(0x41, 0x5a),
        Tuple2(0x61, 0x7a),
        Tuple2(0x30, 0x39),
        Tuple2(0x5f, 0x5f),
        Tuple2(0x24, 0x24)
      ]);
    }
    {
      final state = State('');
      final r = parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(r, null);
    }
    {
      final state = State(' ');
      final r = parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(r, null);
    }
  });
}
