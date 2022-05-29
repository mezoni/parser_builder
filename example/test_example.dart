import 'example.dart';

void main(List<String> args) {
  final text = '{"rocket": "🚀 flies to the stars"}';
  final source = StringReader(text);
  final r = parse(source);
  print(r);
}
