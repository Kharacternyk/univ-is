import 'dart:io';

import 'package:lab_1/knowledge_base.dart';
import 'package:lab_1/lexer.dart';
import 'package:lab_1/parser.dart';
import 'package:lab_1/parsing_result.dart';

void main(List<String> arguments) {
  final base = KnowledgeBase();
  final lexer = Lexer((tokens) {
    switch (parse(tokens)) {
      case Success success:
        base.feed(success.sentence)?.forEach(print);
      case Failure _:
        print(":(Parsing failure):");
      case Waiting _:
    }
  });

  for (;;) {
    final input = stdin.readLineSync(retainNewlines: true);

    if (input case String input) {
      lexer.feed(input);
    } else {
      break;
    }
  }
}
