import 'dart:collection';

import 'package:lab_1/parser.dart';
import 'package:lab_1/parsing_result.dart';
import 'package:lab_1/relation.dart';
import 'package:lab_1/sentence.dart';
import 'package:lab_1/token.dart';
import 'package:test/test.dart';

import 'token_extension.dart';

void main() {
  test('Failure', () {
    final result = parse(Queue.of([
      ["Photoshop"].noun,
      ["runs", "only", "on"].verb,
      Ampersand(),
      ["Windows"].noun,
      Period(),
    ]));

    expect(result, isA<Failure>());
  });

  test('Waiting', () {
    final result = parse(Queue.of([
      ["Photoshop"].noun,
      ["runs", "only", "on"].verb,
      ["Windows"].noun,
    ]));

    expect(result, isA<Waiting>());
  });

  test('Fact', () {
    final result = parse(Queue.of([
      ["Photoshop"].noun,
      ["runs", "only", "on"].verb,
      ["Windows"].noun,
      Period(),
    ]));

    expect(result, isA<Success>());

    final success = result as Success;

    expect(
      success.sentence,
      equals(
        Fact(
          NounFirstRelation(
            ["Photoshop"].noun,
            VerbFirstRelation(
              ["runs", "only", "on"].verb,
              NounFirstRelation(
                ["Windows"].noun,
                null,
              ),
            ),
          ),
        ),
      ),
    );
  });

  test('Rule', () {
    final result = parse(Queue.of([
      If(),
      ["someone"].noun,
      ["uses"].verb,
      ["something"].noun,
      Ampersand(),
      ["something"].noun,
      ["is"].verb,
      ["something", "else"].noun,
      Then(),
      ["someone"].noun,
      ["uses"].verb,
      ["something", "else"].noun,
      Period(),
    ]));

    expect(result, isA<Success>());

    final success = result as Success;

    expect(
      success.sentence,
      equals(
        Rule(
          predicate: NounFirstRelation(
            ["someone"].noun,
            VerbFirstRelation(
              ["uses"].verb,
              NounFirstRelation(
                ["something"].noun,
                null,
              ),
            ),
          ),
          conjunction: NounFirstRelation(
            ["something"].noun,
            VerbFirstRelation(
              ["is"].verb,
              NounFirstRelation(
                ["something", "else"].noun,
                null,
              ),
            ),
          ),
          consequence: NounFirstRelation(
            ["someone"].noun,
            VerbFirstRelation(
              ["uses"].verb,
              NounFirstRelation(
                ["something", "else"].noun,
                null,
              ),
            ),
          ),
        ),
      ),
    );
  });

  test('Query', () {
    final result = parse(Queue.of([
      What(),
      ["Bob"].noun,
      ["uses"].verb,
      QuestionMark(),
    ]));

    expect(result, isA<Success>());

    final success = result as Success;

    expect(
      success.sentence,
      equals(
        Query(
          NounFirstRelation(
            ["Bob"].noun,
            VerbFirstRelation(
              ["uses"].verb,
              null,
            ),
          ),
        ),
      ),
    );
  });
}
