import 'package:bloc/bloc.dart';
import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';
import 'package:lasic_grana_flutter/app/modules/levels_menu/blocs/levels_menu_events.dart';
import 'package:lasic_grana_flutter/app/modules/levels_menu/blocs/levels_menu_states.dart';

class LevelsMenuBloc extends Bloc<LevelsMenuEvent, AppState> {
  LevelsMenuBloc() : super(InitialState()) {
    on<ChangeAvatarPosition>(_changeAvatarPosition);
  }

  int actualLevel = 1;

// Função para mudar a posição do avatar
  Future<void> _changeAvatarPosition(
    ChangeAvatarPosition event,
    Emitter<AppState> emit,
  ) async {
    emit(ChangingAvatarPosition());

    try {
      // funçao
      emit(SuccessfullyChangedAvatarPosition());
    } catch (exception) {
      emit(UnableToChangeAvatarPosition());
    }
  }
}
