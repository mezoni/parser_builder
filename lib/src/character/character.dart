part of '../../character.dart';

abstract class _Chars0 extends ParserBuilder<String, String> {
  const _Chars0();

  @override
  String build(Context context, ParserResult? result) {
    final predicate = _getPredicate();
    final parser = TakeWhile(predicate);
    return parser.build(context, result);
  }

  SemanticAction<bool> _getPredicate();
}

abstract class _Chars1 extends ParserBuilder<String, String> {
  const _Chars1();

  @override
  String build(Context context, ParserResult? result) {
    final predicate = _getPredicate();
    final parser = TakeWhile1(predicate);
    return parser.build(context, result);
  }

  SemanticAction<bool> _getPredicate();
}
