part of '../../error.dart';

@experimental
class LastErrorPositionAction extends SemanticAction<int> {
  const LastErrorPositionAction();

  @override
  String build(Context context, String name, List<String> arguments) {
    return replaceParameters('state.lastErrorPos', const [], arguments);
  }
}
