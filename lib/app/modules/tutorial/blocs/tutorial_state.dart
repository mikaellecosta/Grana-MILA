import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';

// estados para a variavel tutorialList em TutorialBloc
class CreatingTutorialList implements ProcessingState {}

class SuccessfullyCreatedTutorialList implements SuccessState {}

class UnableToCreateTutorialList implements ErrorState {}

// estados para a variavel product em ShopBloc
class ChangingActualTutorial implements ProcessingState {}

class SuccessfullyChangedActualTutorial implements SuccessState {}

class UnableToChangeActualTutorial implements ErrorState {}

// animação
class ChangingActualPigImage implements ProcessingState {}

class SuccessfullyChangingActualPigImage implements SuccessState {}

class UnableToChangingActualPigImage implements ErrorState {}