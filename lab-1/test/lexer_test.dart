import 'package:lab_1/lexer.dart';
import 'package:lab_1/token.dart';
import 'package:test/test.dart';

import 'token_extension.dart';

void main() {
  test('Lexer', () {
    final lexer = Lexer();

    lexer.feed('What Bob *uses*?');

    expect(
      lexer.tokens,
      equals([
        const What(),
        ['Bob'].noun,
        ['uses'].verb,
        const QuestionMark(),
      ]),
    );

    lexer.tokens.clear();
    lexer.feed('''
        If someone *uses* something &
        someone else *is responsible for* bugs *in* something,
        then someone *is angry at* someone else.
    ''');

    expect(
      lexer.tokens,
      equals([
        const If(),
        ['someone'].noun,
        ['uses'].verb,
        ['something'].noun,
        const Ampersand(),
        ['someone', 'else'].noun,
        ['is', 'responsible', 'for'].verb,
        ['bugs'].noun,
        ['in'].verb,
        ['something'].noun,
        const Then(),
        ['someone'].noun,
        ['is', 'angry', 'at'].verb,
        ['someone', 'else'].noun,
        const Period(),
      ]),
    );
  });
}
