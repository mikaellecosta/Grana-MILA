abstract class LevelEvent {}

// Evento para mudar o numero do level em um LevelBloc,
// criando um novo objeto Level
class UpdateLevelInLevelBloc implements LevelEvent {
  const UpdateLevelInLevelBloc({required this.levelNumber});
  final int levelNumber;
}

// Evento para quando o usuario selecionar uma opção de resposta do quiz
class UpdateIsAnswerOptionSelectedInLevelBloc implements LevelEvent {
  const UpdateIsAnswerOptionSelectedInLevelBloc({
    required this.numberQuestion,
  });
  final int numberQuestion;
}

// Evento para mudar de questão
class UpdateActualQuestion implements LevelEvent {
  const UpdateActualQuestion();
}

// Evento para reduzir tempo do Timer maximo de resposta
class ReduceTimer implements LevelEvent {
  const ReduceTimer();
}

// Evento para aumentar moedas ganhas no level
class CorrectQuestionCoinsIncrease implements LevelEvent {
  const CorrectQuestionCoinsIncrease();
}
