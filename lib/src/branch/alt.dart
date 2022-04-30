part of '../../branch.dart';

/// Parses parsers one by one and returns the first successful results.
class Alt<I, O> extends _Alt<I, O> {
  final List<ParserBuilder<I, O>> parsers;

  const Alt(this.parsers);

  @override
  List<ParserBuilder<I, O>> _getParsers() {
    return parsers;
  }
}

/// Parses parsers one by one and returns the first successful results.
class Alt2<I, O> extends _Alt<I, O> {
  final ParserBuilder<I, O> parser1;

  final ParserBuilder<I, O> parser2;

  const Alt2(this.parser1, this.parser2);

  @override
  List<ParserBuilder<I, O>> _getParsers() {
    return [parser1, parser2];
  }
}

/// Parses parsers one by one and returns the first successful results.
class Alt3<I, O> extends _Alt<I, O> {
  final ParserBuilder<I, O> parser1;

  final ParserBuilder<I, O> parser2;

  final ParserBuilder<I, O> parser3;

  const Alt3(this.parser1, this.parser2, this.parser3);

  @override
  List<ParserBuilder<I, O>> _getParsers() {
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
  List<ParserBuilder<I, O>> _getParsers() {
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
  List<ParserBuilder<I, O>> _getParsers() {
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
  List<ParserBuilder<I, O>> _getParsers() {
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
  List<ParserBuilder<I, O>> _getParsers() {
    return [parser1, parser2, parser3, parser4, parser5, parser6, parser7];
  }
}

abstract class _Alt<I, O> extends ParserBuilder<I, O> {
  static const _templateLast = '''
{{p1}}''';

  static const _templateParser = '''
{{p1}}
if (!state.ok) {
  {{next}}
}''';

  const _Alt();

  @override
  String build(Context context, ParserResult? result) {
    final parsers = _getParsers();
    if (parsers.length < 2) {
      throw StateError('The list of parsers must contain at least 2 elements');
    }

    var template = '{{next}}';
    for (var i = 0; i < parsers.length; i++) {
      final parser = parsers[i];
      final values = {
        'p1': parser.build(context, result),
      };
      final isLast = i == parsers.length - 1;
      final templateParser =
          render2(isLast, _templateLast, _templateParser, values);
      values.clear();
      values.addAll({
        'next': templateParser,
      });
      template = render(template, values);
    }

    return render(template, {});
  }

  List<ParserBuilder<I, O>> _getParsers();
}
