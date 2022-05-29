import 'package:parser_builder/src/char_class/char_class_parser.dart';
import 'package:test/test.dart';

void main(List<String> args) {
  _test();
}

State<Utf16Reader> _state(String text) => State(StringReader(text));

void _test() {
  test('CharClassParser', () {
    final parser = parse;
    {
      final state = _state(' "1" ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [Result2(0x31, 0x31)]);
    }
    {
      final state = _state(' #x31 ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [Result2(0x31, 0x31)]);
    }
    {
      final state = _state(' [A-Z] ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [Result2(0x41, 0x5a)]);
    }
    {
      final state = _state(' [#x20-#x7f] ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [Result2(0x20, 0x7f)]);
    }
    {
      final state = _state(' [#x10000-#x10200] ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [Result2(0x10000, 0x10200)]);
    }
    {
      final state = _state(' "1" | [A-Z] ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [Result2(0x31, 0x31), Result2(0x41, 0x5a)]);
    }
    {
      final state = _state(' "1" | [A-Z] | [#x20-#x7f] | [#x10000-#x10200] ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [
        Result2(0x31, 0x31),
        Result2(0x41, 0x5a),
        Result2(0x20, 0x7f),
        Result2(0x10000, 0x10200)
      ]);
    }
    {
      final state = _state(' [1A-Z#x20-#x7f#x10000-#x10200+,-] ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [
        Result2(0x31, 0x31),
        Result2(0x41, 0x5a),
        Result2(0x20, 0x7f),
        Result2(0x10000, 0x10200),
        Result2(0x2b, 0x2b),
        Result2(0x2c, 0x2c),
        Result2(0x2d, 0x2d)
      ]);
    }
    {
      final state = _state(r' [A-Za-z0-9_] | "$" ');
      final r = parser(state);
      expect(state.ok, true);
      expect(r, [
        Result2(0x41, 0x5a),
        Result2(0x61, 0x7a),
        Result2(0x30, 0x39),
        Result2(0x5f, 0x5f),
        Result2(0x24, 0x24)
      ]);
    }
    {
      final state = _state('');
      final r = parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(r, null);
    }
    {
      final state = _state(' ');
      final r = parser(state);
      expect(state.ok, false);
      expect(state.pos, 0);
      expect(r, null);
    }
  });
}
