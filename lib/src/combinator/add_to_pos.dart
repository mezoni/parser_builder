part of '../../combinator.dart';

class AddToPos<I> extends ParserBuilder<I, void> {
  static const _template = '''
state.ok = true;
state.pos += {{value}};''';

  final int value;

  const AddToPos(this.value);

  @override
  String build(Context context, ParserResult? result) {
    final values = {
      'value': '$value',
    };
    return render(_template, values);
  }
}
