part of '../../error.dart';

@experimental
class PositionAction extends SemanticAction<int> {
  const PositionAction();

  @override
  String build(Context context, String name, List<String> arguments) {
    return replaceParameters('state.pos', const [], arguments);
  }
}
