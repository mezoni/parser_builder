import 'hex_color_parser_helper.dart';

part 'hex_color_parser.g.dart';

void main() {
  final s = '#2F14DF';
  final r = parse(StringReader(s));
  print(r);
}
