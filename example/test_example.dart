import 'example.dart';

void main(List<String> args) {
  final source = '{"rocket": "🚀 flies to the stars"}';
  final r = parse(source);
  print(r);
}
