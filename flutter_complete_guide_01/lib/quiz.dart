import 'package:flutter/material.dart';

import './question.dart';
import './anwser.dart';

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final int questionIndex;
  final Function anwserQuestion;

  Quiz(
      {@required this.questions,
      @required this.anwserQuestion,
      @required this.questionIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(
          questions[questionIndex]['questionText'],
        ),
        ...(questions[questionIndex]['answers'] as List<Map<String, Object>>)
            .map((anwser) {
          return Anwser(() => anwserQuestion(anwser['score']), anwser['text']);
        }).toList()
      ],
    );
  }
}
