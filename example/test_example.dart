import 'example.dart';

void main(List<String> args) {
  const source = '{"rocket": "🚀 flies to the stars"}';
  final r = parse(source);
  print(r);
}
