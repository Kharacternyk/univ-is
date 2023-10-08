import 'dart:collection';

import 'parsing_result.dart';
import 'relation.dart';
import 'sentence.dart';
import 'token.dart';

ParsingResult parse(Queue<Token> tokens) {
  switch (tokens.toList()) {
    case [What _, ..., QuestionMark _]:
      tokens.removeFirst();
      tokens.removeLast();
      return _parseQuery(tokens);
    case [..., QuestionMark _]:
      tokens.clear();
      return const Failure();
    case [If _, ..., Period _]:
      tokens.removeFirst();
      tokens.removeLast();
      return _parseRule(tokens);
    case [..., Period _]:
      tokens.removeLast();
      return _parseFact(tokens);
    default:
      return const Waiting();
  }
}

ParsingResult _parseFact(Queue<Token> tokens) {
  final relation = _parseNounFirst(tokens);

  if (relation case NounFirstRelation relation when tokens.isEmpty) {
    return Success(Fact(relation));
  }

  tokens.clear();
  return const Failure();
}

ParsingResult _parseRule(Queue<Token> tokens) {
  final predicate = _parseNounFirst(tokens);

  if (predicate case NounFirstRelation predicate) {
    switch (tokens.firstOrNull) {
      case Then _:
        tokens.removeFirst();
        final consequence = _parseNounFirst(tokens);

        if (consequence case NounFirstRelation consequence
            when tokens.isEmpty) {
          return Success(Rule(
            predicate: predicate,
            consequence: consequence,
          ));
        }
      case Ampersand _:
        tokens.removeFirst();
        final conjunction = _parseNounFirst(tokens);

        if (conjunction case NounFirstRelation conjunction) {
          if (tokens.firstOrNull case Then _) {
            tokens.removeFirst();
            final consequence = _parseNounFirst(tokens);

            if (consequence case NounFirstRelation consequence
                when tokens.isEmpty) {
              return Success(Rule(
                predicate: predicate,
                conjunction: conjunction,
                consequence: consequence,
              ));
            }
          }
        }
      default:
        break;
    }
  }

  tokens.clear();
  return const Failure();
}

ParsingResult _parseQuery(Queue<Token> tokens) {
  final relation = switch (tokens.firstOrNull) {
    Noun _ => _parseNounFirst(tokens),
    Verb _ => _parseVerbFirst(tokens),
    _ => null,
  };

  if (relation case Relation relation when tokens.isEmpty) {
    return Success(Query(relation));
  }

  tokens.clear();
  return const Failure();
}

NounFirstRelation? _parseNounFirst(Queue<Token> tokens) {
  if (tokens.firstOrNull case Noun head) {
    tokens.removeFirst();

    return NounFirstRelation(head, _parseVerbFirst(tokens));
  }

  return null;
}

VerbFirstRelation? _parseVerbFirst(Queue<Token> tokens) {
  if (tokens.firstOrNull case Verb head) {
    tokens.removeFirst();

    return VerbFirstRelation(head, _parseNounFirst(tokens));
  }

  return null;
}
