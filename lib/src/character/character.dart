part of '../../character.dart';

abstract class _Chars0 extends StringParserBuilder<String> {
  const _Chars0();

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final predicate = _getCharacterPredicate();
    final parser = TakeWhile(predicate);
    return parser.build(context, code, result, silent);
  }

  SemanticAction<bool> _getCharacterPredicate();
}

abstract class _Chars1 extends StringParserBuilder<String> {
  const _Chars1();

  @override
  void build(Context context, CodeGen code, ParserResult result, bool silent) {
    final predicate = _getCharacterPredicate();
    final parser = TakeWhile1(predicate);
    return parser.build(context, code, result, silent);
  }

  SemanticAction<bool> _getCharacterPredicate();
}
