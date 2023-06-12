import 'package:lasic_grana_flutter/app/modules/levels/models/question.dart';

class Level {

  Level(
      {required this.number,
      required this.totalQuestions,
      required this.questionsToComplete,
      required this.rewardPerQuestion,
      required this.questions});
  int number;
  int totalQuestions;
  int questionsToComplete;
  int rewardPerQuestion;
  List<Question> questions;
}
