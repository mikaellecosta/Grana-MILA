import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_bloc.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_events.dart';
import 'package:lasic_grana_flutter/app/core/languages/brazilian_portuguese.dart';

class TreasureButton extends StatelessWidget {
  TreasureButton({
    super.key,
    required this.mediaQuery,
    required this.verticalSize,
    required this.horizontalSize,
    required this.chestVerticalSize,
    required this.chestHorizontalSize,
    required this.levelsCompleted,
    required this.thisLevel,
  });

  final MediaQueryData mediaQuery;
  final double verticalSize;
  final double horizontalSize;
  final double chestVerticalSize;
  final double chestHorizontalSize;
  final int levelsCompleted;
  final int thisLevel;

  final userDataBloc = Modular.get<UserDataBloc>();

  @override
  Widget build(BuildContext context) {
    if (levelsCompleted + 1 == thisLevel) {
      // Baú fechado
      return Column(
        children: <Widget>[
          SizedBox(height: mediaQuery.size.height * verticalSize),
          // Botão de fase
          GestureDetector(
            onTap: () {
              Modular.to.navigate('./Level/', arguments: thisLevel);
              userDataBloc.userData.actualLevel = thisLevel;
              userDataBloc.add(const UpdateUserData());
            },
            // imagem do bau fechado
            child: Row(
              children: [
                SizedBox(width: mediaQuery.size.width * horizontalSize),
                SizedBox(
                  height: mediaQuery.size.height * chestVerticalSize,
                  width: mediaQuery.size.width * chestHorizontalSize,
                  child: Image.asset(
                    'assets/images/icon-chest.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    // Baú bloqueado
    if (thisLevel > levelsCompleted + 1) {
      return Column(
        children: <Widget>[
          SizedBox(height: mediaQuery.size.height * verticalSize),
          // Botão de fase
          GestureDetector(
            // Ao apertar no bau bloqueado é mostrado ao usuario um Dialog/AlertDialog customizado
            onTap: () => showDialog(
              context: context,
              builder: (context) => Stack(
                children: [
                  // Imagem de fundo do Dialog
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: mediaQuery.size.width * 0.03),
                      child:
                          Image.asset('assets/images/white-box-background.png'),
                    ),
                  ),
                  // Texto no inicio do Dialog
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: mediaQuery.size.height * 0.37,
                        ),
                        const Text(
                          'Alerta',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                  // Texto no meio do Dialog
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: mediaQuery.size.width * 0.2),
                      child: Column(
                        children: [
                          SizedBox(
                            height: mediaQuery.size.height * 0.45,
                          ),
                          Text(
                            BrazilianPortuguese().lockedLevel,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Botão no fim do Dialog
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: mediaQuery.size.height * 0.55,
                        ),
                        GestureDetector(
                          onTap: () => Modular.to.pop(),
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: mediaQuery.size.height * 0.06,
                                  child: Image.asset(
                                      'assets/images/blue-button-background.png'),
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: mediaQuery.size.height * 0.015,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // imagem do bau bloqueado
            child: Row(
              children: [
                SizedBox(width: mediaQuery.size.width * horizontalSize),
                SizedBox(
                  height: mediaQuery.size.height * chestVerticalSize,
                  width: mediaQuery.size.width * chestHorizontalSize,
                  child: Image.asset(
                    'assets/images/icon-chest-locked.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    // Baú aberto
    if (levelsCompleted >= thisLevel) {
      return Column(
        children: <Widget>[
          SizedBox(height: mediaQuery.size.height * verticalSize),
          // Botão de fase
          GestureDetector(
            onTap: () {
              Modular.to.navigate('./Level/', arguments: thisLevel);
              userDataBloc.userData.actualLevel = thisLevel;
              userDataBloc.add(const UpdateUserData());
            },
            // imagem do bau aberto
            child: Row(
              children: [
                SizedBox(width: mediaQuery.size.width * horizontalSize),
                SizedBox(
                  height: mediaQuery.size.height * chestVerticalSize,
                  width: mediaQuery.size.width * chestHorizontalSize,
                  child: Image.asset(
                    'assets/images/open-chest-icon.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    // Caso nenhum dos casos anteriores seja valido o seguinte
    // sera retornado, mas ele so sera retornado se houver erros no app
    return Container();
  }
}
