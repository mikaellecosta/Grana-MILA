import 'package:bloc/bloc.dart';
import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_events.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_states.dart';
import 'package:lasic_grana_flutter/app/core/models/user_data.dart';

class UserDataBloc extends Bloc<UserDataEvent, AppState> {
  UserDataBloc() : super(InitialState()) {
    on<VerifyIfUserDataExist>(_verifyIfUserDataExist);
    on<CreateNewUserData>(_createNewUserData);
    on<ReadUserData>(_readUserData);
    on<UpdateUserData>(_updateUserData);
  }

  bool isSaved = true;

  late UserData userData;

  /*A maioria das funções abaixo esta aqui pois são assincronas e a forma que
   achei de utiliza-las foi as chamando a partir do bloc
   Função que chama função de UserData que verifica se Save ja exite no 
   armazenamento local*/

  Future<void> _verifyIfUserDataExist(
    VerifyIfUserDataExist event,
    Emitter<AppState> emit,
  ) async {
    emit(VerifyingIfUserDataExist());

    try {
      isSaved = await UserData.userDataExistsInLocalStorage() ? true : false;
      emit(SuccessfullyVerifiedIfUserDataExist());
    } catch (e) {
      emit(UnableToVerifyIfUserDataExist());
    }
  }

  /* Função que chama função de UserData que cria um novo Save e o armazena 
  localmente, tambem definimos os dados de um novo Save */

  Future<void> _createNewUserData(
    CreateNewUserData event,
    Emitter<AppState> emit,
  ) async {
    emit(CreatingNewUserData());

    try {
      userData = UserData(
        coins: 0,
        completedLevels: 0,
        productsPurchased: [],
        skin: '',
        levelsPlayed: {},
        actualLevel: 1,
      );

      await userData.writeUserDataInLocalStorage();
      emit(SuccessfullyCreatedNewUserData());
    } catch (e) {
      emit(UnableToCreateNewUserData());
    }
  }

  /* Função que chama função de UserData que le os dados salvos localmente 
  e armazena em um objeto UserData instanciado neste bloc */

  Future<void> _readUserData(
    ReadUserData event,
    Emitter<AppState> emit,
  ) async {
    emit(ReadingUserData());

    try {
      userData = await UserData.readUserDataInLocalStorage();
      emit(SuccessfullyReadedUserData());
    } catch (e) {
      emit(UnableToReadUserData());
    }
  }

  /* Função que chama função de UserData que atualiza os dados 
  no armazenamento local a partir do objeto UserData instanciado neste bloc */

  Future<void> _updateUserData(
    UpdateUserData event,
    Emitter<AppState> emit,
  ) async {
    emit(UpdatingUserData());

    try {
      await userData.updateUserDataInLocalStorage();
      emit(SuccessfullyUpdatedUserData());
    } catch (e) {
      emit(UnableToUpdateUserData());
    }
  }
}
