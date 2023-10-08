import 'relation.dart';

sealed class Sentence {}

class Fact extends Sentence {
  final NounFirstRelation relation;

  Fact(this.relation);

  @override
  operator ==(Object other) => other is Fact && relation == other.relation;

  @override
  int get hashCode => relation.hashCode;
}

class Rule extends Sentence {
  final NounFirstRelation predicate;
  final NounFirstRelation? conjunction;
  final NounFirstRelation consequence;

  Rule({
    required this.predicate,
    this.conjunction,
    required this.consequence,
  });

  @override
  operator ==(Object other) =>
      other is Rule &&
      predicate == other.predicate &&
      conjunction == other.conjunction &&
      consequence == other.consequence;

  @override
  int get hashCode => Object.hash(predicate, conjunction, consequence);
}

class Query extends Sentence {
  final Relation relation;

  Query(this.relation);

  @override
  operator ==(Object other) => other is Query && relation == other.relation;

  @override
  int get hashCode => relation.hashCode;
}
