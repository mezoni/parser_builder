part of '../../parser_builder.dart';

abstract class ParserBuilder<I, O> {
  const ParserBuilder();

  String build(Context context) {
    init(context);
    final sb = StringBuffer();
    if (context.onEnter != null) {
      final code = context.onEnter!(this);
      if (code != null) {
        sb.writeln(code);
      }
    }

    sb.write(getResultType());
    sb.write(' ');
    sb.write(context.resultVariable);
    sb.writeln(';');
    var code = buildBody(context);
    code = const LineSplitter()
        .convert(code)
        .where((e) => e.trim().isNotEmpty)
        .join('\n');
    sb.writeln(code);
    if (context.onLeave != null) {
      final code = context.onLeave!(this, context.resultVariable);
      if (code != null) {
        sb.writeln(code);
      }
    }

    return sb.toString();
  }

  String buildAndAssign(Context context, String localVariable) {
    final resultVariable = context.resultVariable;
    context.resultVariable = localVariable;
    var result = build(context);
    result = result.trimRight();
    context.resultVariable = resultVariable;
    return result;
  }

  String buildBody(Context context) {
    final builders = getBuilders();
    final tags = getTags(context);
    final template = getTemplate(context);
    final result = buildBodyEx(context, builders, tags, template);
    return result;
  }

  String buildBodyEx(Context context, Map<String, ParserBuilder> builders,
      Map<String, String> tags, String template) {
    final values = {...tags};
    final resultTag = 'res';
    final resultSuffix = '_res';
    final resultValueSuffix = '_val';
    values[resultTag] = context.resultVariable;
    for (final key in builders.keys) {
      final builder = builders[key]!;
      final localVariable = context.allocateLocal();
      final result = builder.buildAndAssign(context, localVariable);
      final builderTag = key;
      final resultTag = builderTag + resultSuffix;
      final valueTag = builderTag + resultValueSuffix;
      final isNullable = builder.isNullableResultType();
      values[builderTag] = result;
      values[resultTag] = localVariable;
      values[valueTag] = localVariable + (isNullable ? '' : '!');
    }

    final result = render(template, values);
    return result;
  }

  Map<String, ParserBuilder> getBuilders() {
    return {};
  }

  String getInputType() {
    return '$I';
  }

  String getResultType() {
    final name = '$O';
    final isNullable = isNullableResultType();
    final result = isNullable ? name : '$name?';
    return result;
  }

  Map<String, String> getTags(Context context) {
    return {};
  }

  String getTemplate(Context context);

  void init(Context context) {
    // Nothing
  }

  bool isNullableResultType() {
    final result = helper.isNullableType<O>();
    return result;
  }

  String printName(List arguments) {
    String plunge(ParserBuilder builder, List arguments) {
      var name = builder.runtimeType.toString();
      final index = name.indexOf('<');
      if (index != -1) {
        name = name.substring(0, index);
      }

      final args = arguments.map((e) {
        if (e is Named) {
          return e.toString();
        } else if (e is ParserBuilder) {
          return plunge(e, const []);
        }

        return e.toString();
      });

      final sb = StringBuffer();
      sb.write(name);
      sb.write('<');
      sb.write(I);
      sb.write(', ');
      sb.write(O);
      sb.write('>(');
      sb.write(args.join(', '));
      sb.write(')');
      return sb.toString();
    }

    final result = plunge(this, arguments);
    return result;
  }

  String render(String template, Map<String, String> values) {
    var result = template;
    for (final key in values.keys) {
      final value = values[key]!;
      result = result.replaceAll('{{$key}}', value);
    }

    return result;
  }

  @override
  String toString() {
    return runtimeType.toString();
  }
}

abstract class StringParserBuilder<O> extends ParserBuilder<String, O> {
  const StringParserBuilder();

  @override
  void init(Context context) {
    context.refersToSourceVariable = true;
    super.init(context);
  }
}
