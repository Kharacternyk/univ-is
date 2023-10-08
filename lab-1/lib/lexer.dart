import 'dart:collection';

import 'package:built_collection/built_collection.dart';
import 'package:characters/characters.dart';

import 'token.dart';

enum _State {
  noun,
  verb,
}

class Lexer {
  final tokens = Queue<Token>();
  final _word = StringBuffer();
  final _phrase = ListBuilder<String>();
  var _state = _State.noun;
  static const _punctuation = {',', ';'};

  final void Function(Queue<Token>)? onTokenPushed;
  Lexer([this.onTokenPushed]);

  void feed(String input) {
    for (final character in input.characters) {
      switch (character) {
        case '.':
          _flushPhrase();
          _pushToken(const Period());
        case '?':
          _flushPhrase();
          _pushToken(const QuestionMark());
        case '&':
          _flushPhrase();
          _pushToken(const Ampersand());
        case '*':
          _flushPhrase();
          _switchState();
        case String character
            when character.trim().isEmpty || _punctuation.contains(character):
          _flushWord();
        case String character:
          _word.write(character);
      }
    }
  }

  void _flushPhrase() {
    _flushWord();

    if (_phrase.isNotEmpty) {
      final phrase = _phrase.build();

      _phrase.clear();

      switch (_state) {
        case _State.noun:
          _pushToken(Noun(phrase));
        case _State.verb:
          _pushToken(Verb(phrase));
      }
    }
  }

  void _flushWord() {
    if (_word.isNotEmpty) {
      final word = _word.toString();

      _word.clear();

      switch (word) {
        case 'If' when _phrase.isEmpty:
          _pushToken(const If());
        case 'What' when _phrase.isEmpty:
        case 'Who' when _phrase.isEmpty:
          _pushToken(const What());
        case 'then':
          _flushPhrase();
          _pushToken(const Then());
        default:
          _phrase.add(word);
      }
    }
  }

  void _switchState() {
    _state = switch (_state) {
      _State.noun => _State.verb,
      _State.verb => _State.noun,
    };
  }

  void _pushToken(Token token) {
    tokens.add(token);
    onTokenPushed?.call(tokens);
  }
}
