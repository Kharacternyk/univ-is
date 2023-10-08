import 'package:built_collection/built_collection.dart';
import 'package:lab_1/token.dart';

extension TokenIterable on Iterable<String> {
  Noun get noun => Noun(BuiltList(this));
  Verb get verb => Verb(BuiltList(this));
}
