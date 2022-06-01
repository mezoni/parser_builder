import 'hex_color_parser_helper.dart';

part 'hex_color_parser.g.dart';

void main() {
  const s = '#2F14DF';
  final r = parse(s);
  print(r);
}
