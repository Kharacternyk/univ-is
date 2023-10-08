import 'token.dart';

sealed class Relation {
  Relation? get tail;
}

class NounFirstRelation extends Relation {
  final Noun head;

  @override
  final VerbFirstRelation? tail;

  NounFirstRelation(this.head, this.tail);

  @override
  operator ==(Object other) =>
      other is NounFirstRelation && head == other.head && tail == other.tail;

  @override
  int get hashCode => Object.hash(head, tail);
}

class VerbFirstRelation extends Relation {
  final Verb head;

  @override
  final NounFirstRelation? tail;

  VerbFirstRelation(this.head, this.tail);

  @override
  operator ==(Object other) =>
      other is VerbFirstRelation && head == other.head && tail == other.tail;

  @override
  int get hashCode => Object.hash(head, tail);
}
