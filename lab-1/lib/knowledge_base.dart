import 'package:built_collection/built_collection.dart';

import 'flat_relation.dart';
import 'relation.dart';
import 'sentence.dart';
import 'token.dart';

class KnowledgeBase {
  final _knownNouns = <Noun>{};
  final _facts = <BuiltList<Verb>, Set<BuiltList<Noun>>>{};
  final _rules = <BuiltList<Verb>, Set<Rule>>{};

  BuiltSet<Noun>? feed(Sentence sentence) {
    switch (sentence) {
      case Fact fact:
        _learnFact(fact);
        return null;
      case Rule rule:
        _learnRule(rule);
        return null;
      case Query query:
        return _evaluate(query);
    }
  }

  void _learnFact(Fact fact) {
    final relation = FlatRelation(fact.relation);

    relation.nouns.forEach(_knownNouns.add);
    _facts[relation.verbs] ??= {};
    _facts[relation.verbs]?.add(relation.nouns);
    _rules[relation.verbs]?.forEach(_learnRule);
  }

  void _learnRule(Rule rule) {
    final predicate = FlatRelation(rule.predicate);
    final consequence = FlatRelation(rule.consequence);
    final conjunction = switch (rule.conjunction) {
      null => null,
      NounFirstRelation relation => FlatRelation(relation),
    };
    final provenNouns = <BuiltList<Noun>>{};

    for (final fact in _facts[predicate.verbs] ?? const <BuiltList<Noun>>[]) {
      final match = _match(fact, predicate.nouns);

      if (match case BuiltMap<Noun?, Noun> match) {
        if (conjunction case FlatRelation conjunction) {
          for (final conjunctionFact
              in _facts[conjunction.verbs] ?? const <BuiltList<Noun>>[]) {
            final conjunctionMatch = _match(conjunctionFact, conjunction.nouns);

            if (conjunctionMatch case BuiltMap<Noun?, Noun> conjunctionMatch) {
              var compatible = true;

              for (final noun in conjunctionMatch.keys) {
                if (match[noun] != null &&
                    conjunctionMatch[noun] != match[noun]) {
                  compatible = false;
                  break;
                }
              }

              if (compatible) {
                final factNouns = consequence.nouns.toBuilder();

                for (var i = 0; i < factNouns.length; ++i) {
                  if (!_knownNouns.contains(factNouns[i])) {
                    if (match[factNouns[i]] case Noun noun) {
                      factNouns[i] = noun;
                    } else if (conjunctionMatch[factNouns[i]] case Noun noun) {
                      factNouns[i] = noun;
                    } else {
                      _knownNouns.add(factNouns[i]);
                    }
                  }
                }

                provenNouns.add(factNouns.build());
              }
            }
          }
        } else {
          final factNouns = consequence.nouns.toBuilder();

          for (var i = 0; i < factNouns.length; ++i) {
            if (!_knownNouns.contains(factNouns[i])) {
              if (match[factNouns[i]] case Noun noun) {
                factNouns[i] = noun;
              } else {
                _knownNouns.add(factNouns[i]);
              }
            }
          }

          provenNouns.add(factNouns.build());
        }
      }
    }

    final hasConsequences =
        provenNouns.difference(_facts[consequence.verbs] ?? {}).isNotEmpty;

    for (final nouns in provenNouns) {
      _facts[consequence.verbs] ??= {};
      _facts[consequence.verbs]?.add(nouns);
    }

    _rules[predicate.verbs] ??= {};
    _rules[predicate.verbs]?.add(rule);

    if (conjunction case FlatRelation conjunction) {
      _rules[conjunction.verbs] ??= {};
      _rules[conjunction.verbs]?.add(rule);
    }

    if (hasConsequences) {
      _rules[consequence.verbs]?.forEach(_learnRule);
    }
  }

  BuiltSet<Noun> _evaluate(Query query) {
    final result = SetBuilder<Noun>();
    final relation = FlatRelation(query.relation);
    final pattern = switch (query.relation) {
      NounFirstRelation _ => BuiltList<Noun?>([...relation.nouns, null]),
      VerbFirstRelation _ => BuiltList<Noun?>([null, ...relation.nouns]),
    };

    for (final fact in _facts[relation.verbs] ?? const <BuiltList<Noun>>[]) {
      final match = _match(fact, pattern);

      if (match?[null] case Noun noun) {
        result.add(noun);
      }
    }

    return result.build();
  }

  BuiltMap<Noun?, Noun>? _match(
    BuiltList<Noun> nouns,
    BuiltList<Noun?> pattern,
  ) {
    if (nouns.length != pattern.length) {
      return null;
    }

    final result = MapBuilder<Noun?, Noun>();

    for (var i = 0; i < nouns.length; ++i) {
      if (!_knownNouns.contains(pattern[i])) {
        result[pattern[i]] = nouns[i];
      } else if (pattern[i] != nouns[i]) {
        return null;
      }
    }

    return result.build();
  }
}
