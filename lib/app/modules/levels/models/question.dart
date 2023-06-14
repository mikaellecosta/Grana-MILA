class Question {
  Question({
    required this.question,
    required this.answerIndex,
    required this.answers,
    required this.tip
  });
  String question;
  int answerIndex;
  List<String> answers;
  String tip;
}
