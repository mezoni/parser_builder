part of '../../branch.dart';

/// Parses parsers one by one and returns the first successful results.
class Alt<I, O> extends _Alt<I, O> {
  final List<ParserBuilder<I, O>> parsers;

  const Alt(this.parsers);

  @override
  List<ParserBuilder<I, O>> getChildren() {
    return parsers;
  }
}

/// Parses parsers one by one and returns the first successful results.
class Alt2<I, O> extends _Alt<I, O> {
  final ParserBuilder<I, O> parser1;

  final ParserBuilder<I, O> parser2;

  const Alt2(this.parser1, this.parser2);

  @override
  List<ParserBuilder<I, O>> getChildren() {
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
  List<ParserBuilder<I, O>> getChildren() {
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
  List<ParserBuilder<I, O>> getChildren() {
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
  List<ParserBuilder<I, O>> getChildren() {
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
  List<ParserBuilder<I, O>> getChildren() {
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
  List<ParserBuilder<I, O>> getChildren() {
    return [parser1, parser2, parser3, parser4, parser5, parser6, parser7];
  }
}

abstract class _Alt<I, O> extends ParserBuilder<I, O> {
  const _Alt();

  @override
  void build(Context context, CodeGen code) {
    final parsers = getChildren();
    if (parsers.length < 2) {
      throw StateError('The list of parsers must contain at least 2 elements');
    }

    final errors = <String>[];
    var silent = code.silent;
    void plunge(int index) {
      final parser = parsers[index];
      helper.build(context, code, parser, result: code.result);
      code.ifFailure((code) {
        if (index < parsers.length - 1) {
          if (!silent) {
            final error = code.val('error', 'state.error');
            errors.add(error);
          }

          plunge(++index);
        } else {
          final list = errors.join(', ');
          code.setError('ErrCombined(state.pos, [$list, state.error])');
        }
      });
    }

    plunge(0);
  }

  List<ParserBuilder<I, O>> getChildren();
}
