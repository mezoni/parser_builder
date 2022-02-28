part of '../../parser_builder.dart';

class Ref<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{res}} = {{name}}(state);''';

  final String name;

  const Ref(this.name);

  @override
  Map<String, String> getTags(Context context) {
    return {
      'name': name,
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([name]);
  }
}
