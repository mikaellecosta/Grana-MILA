import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_bloc.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_events.dart';
import 'package:lasic_grana_flutter/app/core/languages/brazilian_portuguese.dart';
import 'package:lasic_grana_flutter/app/core/widgets/centered_image_button.dart';
import 'package:lasic_grana_flutter/app/core/widgets/centered_image_button_with_text.dart';
import 'package:lasic_grana_flutter/app/core/widgets/pages_background.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_bloc.dart';

class RewardPage extends StatelessWidget {
  RewardPage({super.key});

  final levelBloc = Modular.get<LevelBloc>();
  final userDataBloc = Modular.get<UserDataBloc>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // Olhar a issue da tela de premiação(j)

    // Para quando o usuario errar todas as perguntas
    if (levelBloc.correctQuestions == 0) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            // fundo da tela
            PagesBackground(
                mediaQuery: mediaQuery,
                localImagem: 'assets/images/background-award.png'),
            // Column que é a camada com imagens de fundo e textos
            Column(
              children: <Widget>[
                // Cobre espaço antes da nuvem
                SizedBox(
                  height: mediaQuery.size.height * 0.07,
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.28,
                  width: mediaQuery.size.width * 0.52,
                  child: const Image(
                    image: AssetImage('assets/images/icon-play.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                // Texto que fica dentro da nuvem
                SizedBox(
                  height: mediaQuery.size.height * 0.1,
                  width: mediaQuery.size.width * 0.7,
                  child: Text(
                    BrazilianPortuguese().unfortunately,
                    style: const TextStyle(
                        fontSize: 40, fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.16,
                  width: mediaQuery.size.width * 0.58,
                  child: Text(
                    BrazilianPortuguese().tryAgain,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
                CenteredImageButtonWithText(
                    mediaQuery: mediaQuery,
                    verticalSize: 0.07,
                    horizontalSize: 0.25,
                    localImagem: 'assets/images/yellow-button-background.png',
                    text: 'OK',
                    onTap: () {
                      Modular.to.navigate('../');
                    }),
              ],
            ),
            // Column que é a camada com moeda no topo da tela, numero do nivel
            Column(
              children: <Widget>[
                // Espaço do topo da tela ate widget
                SizedBox(
                  height: mediaQuery.size.height * 0.06,
                ),
                // Moeda no topo da tela
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: mediaQuery.size.height * 0.06,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.13,
                      width: mediaQuery.size.width * 0.26,
                      child: Image.asset(
                        'assets/images/decorative-coin1.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
                // Espaço entre widgets
                SizedBox(
                  height: mediaQuery.size.height * 0.053,
                ),
                // Numero do nivel
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: mediaQuery.size.height * 0.035,
                      width: mediaQuery.size.width * 0.5,
                      child: Text(
                        BrazilianPortuguese()
                            .actualLevel(levelBloc.actualLevel),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 81, 1, 3),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
      // Para quando o usuario responder ao menos 1 pergunta certa
    } else if (levelBloc.correctQuestions != 0) {
      // Soma as moedas do usuario com as moedas ganhas no level
      userDataBloc.userData.coins =
          userDataBloc.userData.coins + levelBloc.levelCoins;
      //Se usuario acerta todas as questões ele pode passar para o proximo level
      if (levelBloc.correctQuestions == levelBloc.level.questionsToComplete &&
          userDataBloc.userData.completedLevels < levelBloc.actualLevel) {
        // Aumenta o valor de leveis completos pelo usuario em 1
        userDataBloc.userData.completedLevels =
            userDataBloc.userData.completedLevels + 1;
        // Passa para o proximo level
        userDataBloc.userData.actualLevel += 1;
      }
      // Salva os dados do usuario no armazenamento local
      userDataBloc.add(const UpdateUserData());
      // Retorna a tela
      return Scaffold(
        body: Stack(
          children: <Widget>[
            // Fundo da tela
            PagesBackground(
                mediaQuery: mediaQuery,
                localImagem: 'assets/images/background-award.png'),
            // Column que é a camada com imagens de fundo e textos
            Column(
              children: [
                // Cobre espaço antes da nuvem
                SizedBox(
                  height: mediaQuery.size.height * 0.08,
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.28,
                  width: mediaQuery.size.width * 0.52,
                  child: const Image(
                    image: AssetImage('assets/images/icon-play.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                // Texto que fica dentro da nuvem
                SizedBox(
                  height: mediaQuery.size.height * 0.08,
                  width: mediaQuery.size.width * 0.7,
                  child: Text(
                    BrazilianPortuguese().congratulations,
                    style: const TextStyle(
                        fontSize: 40, fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Texto informando o numero de moedas ganhas e gastas
                SizedBox(
                  height: mediaQuery.size.height * 0.22,
                  width: mediaQuery.size.width * 0.59,
                  child: Text(
                    BrazilianPortuguese()
                        .rewardValue(levelBloc.correctQuestions),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Botão que "guarda" as moedas ganhas pelo usuario, na verdade
                // ele so o levara para o menu de niveis.
                //
                // Inicialmente era um CenteredImageButton,
                // mas não seria adequado
                // usa-lo aqui, pois ao clicar no texto a função
                // onTap deste Widget não seria executada
                GestureDetector(
                  onTap: () {
                    // Envia o usuario para a tela levels_menu_page
                    Modular.to.navigate('../');
                  },
                  // Stack para colocar a imagem de fundo e o texto por cima
                  child: Stack(
                    children: [
                      // Colocando a imagem
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: mediaQuery.size.height * 0.12,
                            width: mediaQuery.size.width * 0.6,
                            child: const Image(
                              image: AssetImage(
                                'assets/images/save-button.png',
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                      // Colocando o texto
                      SizedBox(
                        height: mediaQuery.size.height * 0.12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: mediaQuery.size.width * 0.22,
                            ),
                            Text(
                              BrazilianPortuguese().spare,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Color.fromARGB(255, 81, 1, 3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Botão que "guarda" as moedas ganhas pelo usuario,
                // na verdade ele so o levara para a loja
                CenteredImageButton(
                    mediaQuery: mediaQuery,
                    verticalSize: 0.12,
                    horizontalSize: 0.6,
                    localImagem: 'assets/images/purchase-button.png',
                    onTap: () {
                      Modular.to.navigate('../Shop/');
                    }),
              ],
            ),
            // Column que é a camada com o numero do nivel
            Column(
              children: [
                // Espaço do topo da tela ate widget
                SizedBox(
                  height: mediaQuery.size.height * 0.25,
                ),
                // Numero do nivel
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: mediaQuery.size.height * 0.035,
                      width: mediaQuery.size.width * 0.5,
                      child: Text(
                        BrazilianPortuguese()
                            .actualLevel(levelBloc.actualLevel),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 81, 1, 3),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Column com 1° moeda do topo da tela
            Column(
              children: [
                // Espaço do topo da tela ate widget
                SizedBox(
                  height: mediaQuery.size.height * 0.065,
                ),
                // Moeda no topo da tela
                Row(
                  children: <Widget>[
                    // 1° moeda
                    SizedBox(
                      width: mediaQuery.size.width * 0.14,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.13,
                      width: mediaQuery.size.width * 0.24,
                      child: Image.asset(
                        'assets/images/decorative-coin1.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Column com 2° moeda do topo da tela
            Column(
              children: [
                Row(
                  children: <Widget>[
                    // 2° moeda
                    SizedBox(
                      width: mediaQuery.size.width * 0.34,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.21,
                      width: mediaQuery.size.width * 0.39,
                      child: Image.asset(
                        'assets/images/decorative-coin2.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Column com 3° moeda do topo da tela
            Column(
              children: [
                // Espaço do topo da tela ate widget
                SizedBox(
                  height: mediaQuery.size.height * 0.065,
                ),
                // Moeda no topo da tela
                Row(
                  children: <Widget>[
                    // 3° moeda
                    SizedBox(
                      width: mediaQuery.size.width * 0.63,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.13,
                      width: mediaQuery.size.width * 0.24,
                      child: Image.asset(
                        'assets/images/decorative-coin3.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }
    return const Center(child: Text('Error'));
  }
}
