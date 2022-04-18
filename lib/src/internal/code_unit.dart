import '../../codegen/code_gen.dart';
import '../../parser_builder.dart';

class CodeUnit extends ParserBuilder<String, int> {
  const CodeUnit();

  @override
  void build(Context context, CodeGen code) {
    context.refersToStateSource = true;
    code.isNotEof();
    code.ifSuccess((code) {
      if (code.fast) {
        code + 'source.codeUnitAt(state.pos++);';
      } else {
        code.setResult('source.codeUnitAt(state.pos++)');
      }
    }, else_: ((code) {
      code.errorUnexpectedEof();
    }));
  }
}
