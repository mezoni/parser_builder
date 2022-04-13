part of '../../character.dart';

abstract class _Chars0 extends Redirect<String, String> {
  const _Chars0();

  @override
  ParserBuilder<String, String> getRedirectParser() {
    final predicate = _getCharacterPredicate();
    final parser = TakeWhile(predicate);
    return parser;
  }

  SemanticAction<bool> _getCharacterPredicate();
}

abstract class _Chars1 extends Redirect<String, String> {
  const _Chars1();

  @override
  ParserBuilder<String, String> getRedirectParser() {
    final predicate = _getCharacterPredicate();
    final parser = TakeWhile1(predicate);
    return parser;
  }

  SemanticAction<bool> _getCharacterPredicate();
}
