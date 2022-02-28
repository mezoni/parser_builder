import 'package:tuple/tuple.dart';

int fromHex(String s) => int.parse(s, radix: 16);

bool isHexDigit(x) =>
    x >= 0x30 && x <= 0x39 || x >= 0x41 && x <= 0x46 || x >= 0x61 && x <= 0x66;

Color toColor(Tuple3<int, int, int> x) => Color(x.item1, x.item2, x.item3);

class Color {
  final int red;
  final int green;
  final int blue;

  const Color(this.red, this.green, this.blue);

  @override
  String toString() {
    return 'Color($red, $green, $blue)';
  }
}
