part of '../../parser_builder.dart';

class SemanticValue<T> {
  final String name;

  SemanticValue(this.name);

  bool get isNullable => helper.isNullableType<T>();

  String get safeValue {
    return '$name as $T';
  }

  String get value {
    if (helper.isNullableType<T>()) {
      return name;
    }

    return '$name!';
  }
}

class Val<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{p1}}
if (state.ok) {
  {{value}} = {{res0}};
}''';

  static const _templateFast = '''
{{var0}}
{{p0}}
if (state.ok) {
  {{value}} = {{res0}};
}''';

  final String name;

  final ParserBuilder<I, O> parser;

  const Val(this.name, this.parser);

  @override
  String build(Context context, ParserResult? result) {
    final fast = result == null;
    final value = context.allocateSematicValue<O>(name);
    final r1 = fast ? context.getResult(parser, true) : result;
    final values = {
      'p0': Slow(parser).build(context, r1),
      'value': value.name,
    };
    return render2(fast, _templateFast, _template, values, [r1]);
  }
}

class PosToVal<I> extends ParserBuilder<I, void> {
  static const _template = '''
state.ok = true;
if (state.ok) {
  {{value}} = state.pos;
}''';

  final String name;

  const PosToVal(this.name);

  @override
  String build(Context context, ParserResult? result) {
    final value = context.allocateSematicValue<int>(name);
    final values = {
      'value': value.name,
    };
    return render(_template, values);
  }
}
