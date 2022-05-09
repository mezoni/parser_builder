part of '../../parser_builder.dart';

class Ref<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{res0}} = {{name}}(state);''';

  static const _templateFast = '''
{{name}}(state);''';

  final String name;

  const Ref(this.name);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final values = {
      'name': name,
    };
    return render2(fast, _templateFast, _template, values, [result]);
  }
}
