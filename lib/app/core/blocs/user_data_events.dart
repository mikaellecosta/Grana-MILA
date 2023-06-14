abstract class UserDataEvent {}

// Evento para verificar se ja existi um Save do usuario armazenado localmente
class VerifyIfUserDataExist implements UserDataEvent {
  const VerifyIfUserDataExist();
}

// Evento para criar um novo Save de usuario e armazena-lo localmente
class CreateNewUserData implements UserDataEvent {
  // TODO(YuriOliv): deve precisar receber a string da skin do usuario
  const CreateNewUserData();
}

// Evento para ler um Save de usuario ja armazenado localmente
class ReadUserData implements UserDataEvent {
  const ReadUserData();
}

/* Evento para atualizar os dados de usuario armazenados 
localmente com o objeto UserData do UserDataBloc */
class UpdateUserData implements UserDataEvent {
  const UpdateUserData();
}
