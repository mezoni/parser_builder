part of '../../character.dart';

abstract class _Chars0 extends Redirect<String, String> {
  const _Chars0();

  @override
  ParserBuilder<String, String> getRedirectParser() {
    final predicate = _getCharacterPredicate();
    return TakeWhile(predicate);
  }

  SemanticAction<bool> _getCharacterPredicate();
}

abstract class _Chars1 extends Redirect<String, String> {
  const _Chars1();

  @override
  ParserBuilder<String, String> getRedirectParser() {
    final predicate = _getCharacterPredicate();
    return TakeWhile1(predicate);
  }

  SemanticAction<bool> _getCharacterPredicate();
}
