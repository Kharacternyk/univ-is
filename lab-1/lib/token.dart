import 'package:built_collection/built_collection.dart';

sealed class Token {
  const Token();
}

class Period extends Token {
  const Period();
}

class QuestionMark extends Token {
  const QuestionMark();
}

class Ampersand extends Token {
  const Ampersand();
}

class If extends Token {
  const If();
}

class What extends Token {
  const What();
}

class Then extends Token {
  const Then();
}

sealed class PhraseToken extends Token {
  final BuiltList<String> phrase;

  PhraseToken(this.phrase);

  @override
  toString() => phrase.join(' ');
}

class Noun extends PhraseToken {
  Noun(super.phrase);

  @override
  operator ==(Object other) => other is Noun && phrase == other.phrase;

  @override
  int get hashCode => phrase.hashCode;
}

class Verb extends PhraseToken {
  Verb(super.phrase);

  @override
  operator ==(Object other) => other is Verb && phrase == other.phrase;

  @override
  int get hashCode => phrase.hashCode;
}
