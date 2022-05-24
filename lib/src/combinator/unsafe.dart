part of '../../combinator.dart';

class Unsafe<I> extends ParserBuilder<I, void> {
  static const _template = '''
state.ok = true;
{{code}}''';

  final String code;

  const Unsafe(this.code);

  @override
  String build(Context context, ParserResult? result) {
    final values = {
      'code': code,
    };
    return render(_template, values);
  }
}
