import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';

// Estados para verificar se Save do usuario ja foi criado
class VerifyingIfUserDataExist implements ProcessingState {}

class SuccessfullyVerifiedIfUserDataExist implements SuccessState {}

class UnableToVerifyIfUserDataExist implements ErrorState {}

// Estados para criação de um novo Save de usuario
class CreatingNewUserData implements ProcessingState {}

class SuccessfullyCreatedNewUserData implements SuccessState {}

class UnableToCreateNewUserData implements ErrorState {}

// Estados para ler o Save do usuario ja armazenado
class ReadingUserData implements ProcessingState {}

class SuccessfullyReadedUserData implements SuccessState {}

class UnableToReadUserData implements ErrorState {}

// Estados para atualizar o Save do usuario ja armazenado
class UpdatingUserData implements ProcessingState {}

class SuccessfullyUpdatedUserData implements SuccessState {}

class UnableToUpdateUserData implements ErrorState {}

// Estados para comprar o produto
class BuyingProduct implements ProcessingState {}
class SuccessBuyingProduct implements SuccessState {}
class UnableToBuyProduct implements ErrorState {}
