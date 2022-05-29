part of '../../combinator.dart';

class Advance<I> extends ParserBuilder<I, void> {
  static const _template = '''
state.ok = true;
state.pos += {{value}};''';

  final int value;

  const Advance(this.value);

  @override
  String build(Context context, ParserResult? result) {
    final values = {
      'value': '$value',
    };
    return render(_template, values);
  }
}
