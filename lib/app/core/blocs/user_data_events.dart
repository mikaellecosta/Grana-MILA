import 'package:lasic_grana_flutter/app/modules/shop/models/product.dart';

abstract class UserDataEvent {}

// Evento para verificar se ja existi um Save do usuario armazenado localmente
class VerifyIfUserDataExist implements UserDataEvent {
  const VerifyIfUserDataExist();
}

// Evento para criar um novo Save de usuario e armazena-lo localmente
class CreateNewUserData implements UserDataEvent {
  CreateNewUserData({required this.skin});
  String skin;
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

class BuyProduct implements UserDataEvent {
  BuyProduct({required this.product});
  final Product product;
}
