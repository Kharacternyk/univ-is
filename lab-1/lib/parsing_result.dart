import 'sentence.dart';

sealed class ParsingResult {
  const ParsingResult();
}

class Success extends ParsingResult {
  final Sentence sentence;

  Success(this.sentence);
}

class Failure extends ParsingResult {
  const Failure();
}

class Waiting extends ParsingResult {
  const Waiting();
}
