import 'package:flutter/material.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_bloc.dart';


class AppTypography {
  // TODO(YuriOliv): perguntar ao albert qual a fonte do texto
  static const fontFamily = 'Gorditas';

  static TextStyle font14Bold() => const TextStyle(
    fontSize: 14, fontWeight: FontWeight.bold);
  
  static TextStyle font16() => const TextStyle(fontSize: 16);
  static TextStyle font16Bold() => const TextStyle(
    fontSize: 16, fontWeight: FontWeight.bold);

  static TextStyle font20() => const TextStyle(fontSize: 20);  
  static TextStyle font20Bold() => const TextStyle(
    fontSize: 20, fontWeight: FontWeight.bold);

  static TextStyle font22Bold() => const TextStyle(
    fontSize: 22, fontWeight: FontWeight.bold);

  static TextStyle font24() => const TextStyle(fontSize: 24);
  static TextStyle font24Bold() => const TextStyle(
    fontSize: 24, fontWeight: FontWeight.bold);
  static TextStyle font24BoldColor() => const TextStyle(
    fontSize: 24, fontWeight: FontWeight.bold, 
    color: Color.fromARGB(255, 81, 1, 3)
    );
  static TextStyle font24BoldColorWhite() => const TextStyle(
    fontSize: 24, fontWeight: FontWeight.bold, 
    color: Colors.white
    );  

  font24BoldSelect(LevelBloc levelBloc) {
    return TextStyle(
    fontSize: 24, fontWeight: FontWeight.bold, 
    color: levelBloc.level.questions[levelBloc.actualQuestion]
                                              .answerIndex ==
                                          levelBloc.optionSelected
                                      ? Colors.green
                                      : Colors.red,);
  }


  static TextStyle font26BoldColor() => const TextStyle(
    fontSize: 26, fontWeight: FontWeight.bold, 
    color: Color.fromARGB(255, 81, 1, 3)
    );

  static TextStyle font28Bold() => const TextStyle(
    fontSize: 28, fontWeight: FontWeight.bold);
  static TextStyle font28BoldColor() => const TextStyle(
    fontSize: 28, fontWeight: FontWeight.bold, color: 
    Color.fromARGB(255, 255, 0, 0)
    ); 

  static TextStyle font40Bold() => const TextStyle(
    fontSize: 40, fontWeight: FontWeight.bold); 


}
