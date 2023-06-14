import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';

// estados para a variavel productList em ShopBloc
class CreatingProductList implements ProcessingState {}

class SuccessfullyCreatedProductList implements SuccessState {}

class UnableToCreateProductList implements ErrorState {}

// estados para a variavel product em ShopBloc
class ChangingActualProduct implements ProcessingState {}

class SuccessfullyChangedActualProduct implements SuccessState {}

class UnableToChangeActualProduct implements ErrorState {}

