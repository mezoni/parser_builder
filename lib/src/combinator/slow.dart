part of '../../combinator.dart';

@experimental
class Slow<I> extends ParserBuilder<I, void> {
  static const _temeplateFast = '''
 // ignore: unused_local_variable
{{var0}}
{{p1}}''';

  final ParserBuilder<I, dynamic> parser;

  const Slow(this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    if (fast) {
      final r1 = context.getResult(parser, true);
      final values = {
        'p1': parser.build(context, r1),
      };
      return render(_temeplateFast, values, [r1]);
    } else {
      return parser.build(context, result);
    }
  }
}
