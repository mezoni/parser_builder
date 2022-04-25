part of '../../expression.dart';

class IdentifierExpression extends ParserBuilder<String, String> {
  final SemanticAction<bool> identCont;

  final SemanticAction<bool> identStart;

  final List<String> reservedWords;

  const IdentifierExpression(
      this.reservedWords, this.identStart, this.identCont);

  @override
  String build(Context context, ParserResult? result) {
    return Expected(
        'identifier',
        Recognize(Tuple3(
          Not(Pair(Tags(reservedWords), Not(Satisfy(identCont)))),
          TakeWhile1(identStart),
          TakeWhile(identCont),
        ))).build(context, result);
  }
}
