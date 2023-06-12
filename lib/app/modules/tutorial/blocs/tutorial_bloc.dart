import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';
import 'package:lasic_grana_flutter/app/core/languages/brazilian_portuguese.dart';
import 'package:lasic_grana_flutter/app/modules/tutorial/blocs/tutorial_event.dart';
import 'package:lasic_grana_flutter/app/modules/tutorial/blocs/tutorial_state.dart';

class TutorialBloc extends Bloc<TutorialEvent, AppState> {
  TutorialBloc() : super(InitialState()) {
    on<NextPigImage>(_nextPigImage);
    on<CreateTutorialList>(_createTutorialList);
    on<NextTutorial>(_nextTutorial);
  }

  late List tutorialList;
  int actualTutorial = 0;

  int actualPigImage = 0;
  final List pigList = [
    'assets/images/pig1.png',
    'assets/images/pig2.png',
    'assets/images/pig3.png',
  ];

  // Função para passar animação
  Future<void> _nextPigImage(NextPigImage event, Emitter<AppState> emit) async {
    emit(ChangingActualPigImage());

    try {
      actualPigImage = actualPigImage + 1;
      emit(SuccessfullyChangingActualPigImage());
    } catch (exception) {
      emit(UnableToChangingActualPigImage());
    }
  }

  // Função para criar lista de textos do tutorial
  Future<void> _createTutorialList(
      CreateTutorialList event, Emitter<AppState> emit) async {
    emit(CreatingTutorialList());

    try {
      tutorialList = BrazilianPortuguese().tutorialList;
      emit(SuccessfullyCreatedTutorialList());
    } catch (exception) {
      emit(UnableToCreateTutorialList());
    }
  }

  //Função para proximo texto do tutorial
  Future<void> _nextTutorial(NextTutorial event, Emitter<AppState> emit) async {
    emit(ChangingActualTutorial());

    try {
      actualTutorial = actualTutorial + 1;
      emit(SuccessfullyChangedActualTutorial());
    } catch (exception) {
      emit(UnableToChangeActualTutorial());
    }
  }
}
