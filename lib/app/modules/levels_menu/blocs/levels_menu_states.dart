import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';

abstract class LevelsMenuState {}

//Estado para mudar a posição da skin de acordo com o ultimo level acessado
class ChangingAvatarPosition extends ProcessingState {}

class SuccessfullyChangedAvatarPosition implements SuccessState {}

class UnableToChangeAvatarPosition implements ErrorState {}
