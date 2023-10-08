import 'package:built_collection/built_collection.dart';

import 'relation.dart';
import 'token.dart';

class FlatRelation {
  final BuiltList<Noun> nouns;
  final BuiltList<Verb> verbs;

  FlatRelation._(this.nouns, this.verbs);

  factory FlatRelation(Relation recursiveRelation) {
    final nouns = ListBuilder<Noun>();
    final verbs = ListBuilder<Verb>();

    for (Relation? relation = recursiveRelation;
        relation != null;
        relation = relation.tail) {
      switch (relation) {
        case NounFirstRelation relation:
          nouns.add(relation.head);
        case VerbFirstRelation relation:
          verbs.add(relation.head);
      }
    }

    return FlatRelation._(nouns.build(), verbs.build());
  }
}
