import 'package:bloc/bloc.dart';
import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_events.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_states.dart';
import 'package:lasic_grana_flutter/app/modules/levels/models/level.dart';
import 'package:lasic_grana_flutter/services/remote_config_service.dart';

class LevelBloc extends Bloc<LevelEvent, AppState> {
  LevelBloc() : super(InitialState()) {
    on<UpdateLevelInLevelBloc>(_onUpdateLevelInLevelBloc);
    on<UpdateIsAnswerOptionSelectedInLevelBloc>(
        _onUpdateIsAnswerOptionSelectedInLevelBloc);
    on<UpdateActualQuestion>(_onUpdateActualQuestion);
    on<CorrectQuestionCoinsIncrease>(_correctQuestionCoinsIncrease);
    on<ReduceTimer>(_reduceTimer);
  }

  // Variaveis para controlar o level
  late Level level;
  int actualLevel = 0;

  // Variaveis para controlar a seleção de perguntas
  int actualQuestion = 0;
  bool isAnswerOptionSelected = false;
  int optionSelected = -1;

  // Variaveis para controlar a ordem das questões e respostas
  List<int> orderQuestions = [];
  List<int> orderAnswers = [];
  int auxQuestionNumber = 0;

  // Variaveis de tempo maximo para responder
  int timerToAnswer = 60;
  bool isTimeActive = false;

  // Variaveis para modificar os dados do usuario no final do level
  int correctQuestions = 0;
  bool isActualQuestionMoneyAlreadyIncreased = false;
  int levelCoins = 0;

  // Preparar o level e outras variaveis necessarias antes de iniciar o quiz
  Future<void> _onUpdateLevelInLevelBloc(
    UpdateLevelInLevelBloc event,
    Emitter<AppState> emit,
  ) async {
    emit(UpdatingLevel());

    try {
      actualLevel = event.levelNumber;
      level = RemoteConfigService().getLevel(event.levelNumber);
      // Cria a ordem das questões
      orderQuestions = List.generate(level.totalQuestions, (index) => index);
      orderQuestions.shuffle();
      // Muda a questão inicial para a primeira questão de orderQuestions
      actualQuestion = orderQuestions.first;

      // Cria uma nova ordem de respostas
      orderAnswers = [0, 1, 2, 3];
      orderAnswers.shuffle();

      emit(SuccessfullyUpdateLevel());
    } catch (exception) {
      emit(UnableToUpdateLevel());
    }
  }

  // Função para quando usuario selecionar uma resposta do quiz
  Future<void> _onUpdateIsAnswerOptionSelectedInLevelBloc(
    UpdateIsAnswerOptionSelectedInLevelBloc event,
    Emitter<AppState> emit,
  ) async {
    emit(UpdatingIsAnswerOptionSelected());

    try {
      isAnswerOptionSelected = true;
      optionSelected = event.numberQuestion;
      emit(SuccessfullyUpdateIsAnswerOptionSelected());
    } catch (exception) {
      emit(UnableToUpdateIsAnswerOptionSelected());
    }
  }

  // Função para mudar para a proxima questão
  Future<void> _onUpdateActualQuestion(
    UpdateActualQuestion event,
    Emitter<AppState> emit,
  ) async {
    emit(UpdatingActualQuestion());

    try {
      timerToAnswer = 60;
      isActualQuestionMoneyAlreadyIncreased = false;
      isAnswerOptionSelected = false;
      actualQuestion = orderQuestions[auxQuestionNumber];
      // Cria uma nova ordem de respostas
      orderAnswers.shuffle();

      emit(SuccessfullyUpdateActualQuestion());
    } catch (exception) {
      emit(UnableToUpdateIsAnswerOptionSelected());
    }
  }

  // Função para adicionar moedas por questão correta
  Future<void> _correctQuestionCoinsIncrease(
    CorrectQuestionCoinsIncrease event,
    Emitter<AppState> emit,
  ) async {
    emit(IncreasingQuestionCoins());

    try {
      // Caso o usuario tenha respondido corretamente,
      // é adicionado 1 ao numero de respostas corretas do usuario
      if (!isActualQuestionMoneyAlreadyIncreased &&
          optionSelected == level.questions[actualQuestion].answerIndex) {
        correctQuestions = correctQuestions + 1;
        levelCoins = levelCoins + 200;
      }
      auxQuestionNumber = auxQuestionNumber + 1;
      isActualQuestionMoneyAlreadyIncreased = true;
      emit(SucessfullyIncreasedQuestionCoins());
    } catch (exception) {
      emit(UnableToIncreaseQuestionCoins());
    }
  }

  // Função que reduz timer em 1 segundo
  Future<void> _reduceTimer(
    ReduceTimer event,
    Emitter<AppState> emit,
  ) async {
    emit(ReducingTimer());

    try {
      timerToAnswer = timerToAnswer - 1;
      emit(SuccessfullyReduceTimer());
    } catch (exception) {
      emit(UnableToReduceTimer());
    }
  }
}
