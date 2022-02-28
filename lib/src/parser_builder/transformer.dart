part of '../../parser_builder.dart';

class Transformer<I, O> {
  final String parameter;

  final String _code;

  const Transformer(this.parameter,
      [this._code = '=> throw UnimplementedError();']);

  String getCode() {
    return _code;
  }

  String transform(String name) {
    var code = getCode().trim();
    if (code.startsWith('=>') && code.endsWith(';') ||
        code.startsWith('{') && code.endsWith('}')) {
      return '$O $name($I $parameter) $code';
    } else {
      return 'final $name = $code;';
    }
  }
}

class TX<I, O> extends Transformer<I, O> {
  const TX(String code) : super('x', code);
}
