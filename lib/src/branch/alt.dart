part of '../../branch.dart';

/// Parses parsers one by one and returns the first successful results.
class Alt<I, O> extends _Alt<I, O> {
  final List<ParserBuilder<I, O>> parsers;

  const Alt(this.parsers);

  @override
  List<ParserBuilder<I, O>> _getAltParsers() {
    return parsers;
  }
}

/// Parses parsers one by one and returns the first successful results.
class Alt2<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
{{p1}}
if (state.ok) {
  {{res}} = {{p1_val}};
} else {
  final {{error}} = state.error;
  {{p2}}
  if (state.ok) {
    {{res}} = {{p2_val}};
  } else if (state.log) {
    state.error = ErrCombined(state.pos, [{{error}}, state.error]);
  }
}''';

  final ParserBuilder<I, O> parser1;

  final ParserBuilder<I, O> parser2;

  const Alt2(this.parser1, this.parser2);

  @override
  Map<String, ParserBuilder> getBuilders() {
    return {
      'p1': parser1,
      'p2': parser2,
    };
  }

  @override
  Map<String, String> getTags(Context context) {
    return context.allocateLocals(['error']);
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName([parser1, parser2]);
  }
}

/// Parses parsers one by one and returns the first successful results.
class Alt3<I, O> extends _Alt<I, O> {
  final ParserBuilder<I, O> parser1;

  final ParserBuilder<I, O> parser2;

  final ParserBuilder<I, O> parser3;

  const Alt3(this.parser1, this.parser2, this.parser3);

  @override
  List<ParserBuilder<I, O>> _getAltParsers() {
    return [parser1, parser2, parser3];
  }
}

/// Parses parsers one by one and returns the first successful results.
class Alt4<I, O> extends _Alt<I, O> {
  final ParserBuilder<I, O> parser1;

  final ParserBuilder<I, O> parser2;

  final ParserBuilder<I, O> parser3;

  final ParserBuilder<I, O> parser4;

  const Alt4(this.parser1, this.parser2, this.parser3, this.parser4);

  @override
  List<ParserBuilder<I, O>> _getAltParsers() {
    return [parser1, parser2, parser3, parser4];
  }
}

/// Parses parsers one by one and returns the first successful results.
class Alt5<I, O> extends _Alt<I, O> {
  final ParserBuilder<I, O> parser1;

  final ParserBuilder<I, O> parser2;

  final ParserBuilder<I, O> parser3;

  final ParserBuilder<I, O> parser4;

  final ParserBuilder<I, O> parser5;

  const Alt5(
      this.parser1, this.parser2, this.parser3, this.parser4, this.parser5);

  @override
  List<ParserBuilder<I, O>> _getAltParsers() {
    return [parser1, parser2, parser3, parser4, parser5];
  }
}

/// Parses parsers one by one and returns the first successful results.
class Alt6<I, O> extends _Alt<I, O> {
  final ParserBuilder<I, O> parser1;

  final ParserBuilder<I, O> parser2;

  final ParserBuilder<I, O> parser3;

  final ParserBuilder<I, O> parser4;

  final ParserBuilder<I, O> parser5;

  final ParserBuilder<I, O> parser6;

  const Alt6(this.parser1, this.parser2, this.parser3, this.parser4,
      this.parser5, this.parser6);

  @override
  List<ParserBuilder<I, O>> _getAltParsers() {
    return [parser1, parser2, parser3, parser4, parser5, parser6];
  }
}

/// Parses parsers one by one and returns the first successful results.
class Alt7<I, O> extends _Alt<I, O> {
  final ParserBuilder<I, O> parser1;

  final ParserBuilder<I, O> parser2;

  final ParserBuilder<I, O> parser3;

  final ParserBuilder<I, O> parser4;

  final ParserBuilder<I, O> parser5;

  final ParserBuilder<I, O> parser6;

  final ParserBuilder<I, O> parser7;

  const Alt7(this.parser1, this.parser2, this.parser3, this.parser4,
      this.parser5, this.parser6, this.parser7);

  @override
  List<ParserBuilder<I, O>> _getAltParsers() {
    return [parser1, parser2, parser3, parser4, parser5, parser6, parser7];
  }
}

abstract class _Alt<I, O> extends ParserBuilder<I, O> {
  static const _template = '''
for (;;) {
  {{body}}
  if (state.log) {
    state.error = ErrCombined(state.pos, [{{errors}}]);
  }
  break;
}''';

  static const _templateChoice = '''
{{p2}}
if (state.ok) {
  {{res}} = {{p2_res}};
  break;
}
final {{e}} = state.error;''';

  const _Alt();

  @override
  Map<String, String> getTags(Context context) {
    final parsers = _getAltParsers();
    final errors = <String>[];
    final body = StringBuffer();
    for (var i = 0; i < parsers.length; i++) {
      final p = parsers[i];
      final r = context.allocateLocal();
      final e = context.allocateLocal();
      errors.add(e);
      final values = {
        'e': e,
        'p2': p.buildAndAssign(context, r),
        'p2_res': r,
        'res': context.resultVariable,
      };
      final code = render(_templateChoice, values);
      body.write(code);
    }

    return {
      'errors': errors.join(', '),
      'body': body.toString(),
    };
  }

  @override
  String getTemplate(Context context) {
    return _template;
  }

  @override
  String toString() {
    return printName(_getAltParsers());
  }

  List<ParserBuilder<I, O>> _getAltParsers();
}
