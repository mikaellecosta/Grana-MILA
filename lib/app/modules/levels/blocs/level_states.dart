import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';

// estados para a variavel level em LevelBloc
class UpdatingLevel implements ProcessingState {}

class SuccessfullyUpdateLevel implements SuccessState {}

class UnableToUpdateLevel implements ErrorState {}

// estados para a variavel isAnswerOptionSelected em LevelBloc
class UpdatingIsAnswerOptionSelected implements ProcessingState {}

class SuccessfullyUpdateIsAnswerOptionSelected implements SuccessState {}

class UnableToUpdateIsAnswerOptionSelected implements ErrorState {}

// estados para a variavel actualQuestion em LevelBloc
class UpdatingActualQuestion implements ProcessingState {}

class SuccessfullyUpdateActualQuestion implements SuccessState {}

class UnableToUpdateActualQuestion implements ErrorState {}

// estados para a variavel timerToAnswer em LevelBloc
class ReducingTimer implements ProcessingState {}

class SuccessfullyReduceTimer implements SuccessState {}

class UnableToReduceTimer implements ErrorState {}

// estados para a variavel de levelCoins e correctQuestions em levelBloc
class IncreasingQuestionCoins implements ProcessingState {}

class SucessfullyIncreasedQuestionCoins implements SuccessState {}

class UnableToIncreaseQuestionCoins implements ErrorState {}
