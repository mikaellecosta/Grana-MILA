import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_bloc.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_events.dart';
import 'package:lasic_grana_flutter/app/core/languages/brazilian_portuguese.dart';
import 'package:lasic_grana_flutter/app/core/utils/typography.dart';
import 'package:lasic_grana_flutter/app/core/widgets/pages_background.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_bloc.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_events.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_states.dart';
import 'package:lasic_grana_flutter/app/modules/levels/widgets/answer_option_buttons.dart';

class AnswerOptionsPage extends StatefulWidget {
  const AnswerOptionsPage({super.key});

  @override
  State<AnswerOptionsPage> createState() => _AnswerOptionsPageState();
}

class _AnswerOptionsPageState extends State<AnswerOptionsPage> {
  final levelBloc = Modular.get<LevelBloc>();
  final userDataBloc = Modular.get<UserDataBloc>();

  Timer? timer;
  Timer? timerToAnswerQuestion;

  @override
  void initState() {
    levelBloc.optionSelected = -1;

    // TODO(YuriOliv): Resolver bug no Timer ao minimizar e voltar.
    // Timer ate a resposta ser dada como errada e passar para a proxima
    timerToAnswerQuestion = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!levelBloc.isAnswerOptionSelected) {
        if (levelBloc.isTimeActive == true){
              timer?.cancel();
    timerToAnswerQuestion?.cancel();
            }
        else if  (levelBloc.timerToAnswer > 0) {
          levelBloc.add(const ReduceTimer());
        } 
            
        else {
          // É necessario para o timerToAnswerQuestion
          timerToAnswerQuestion?.cancel();
          // Função que verifica o acerto da questão e adiciona as moedas
          // Colocar aqui pois ela é necessaria para passar de questão
          levelBloc.add(const CorrectQuestionCoinsIncrease());
            
          // Inicia um timer para passar para proxima tela
          // Passa para a proxima questão, até o fim da quantidade de
          // questões do level
          if (levelBloc.auxQuestionNumber <
              levelBloc.level.questionsToComplete - 1) {
            timer = Timer(const Duration(seconds: 1), () {
              Modular.to.navigate('./Question');
            });
          }
          // Se o usuario ja tiver completado esse level antes,
          // Ele é mandado para o menu de leveis
          else if (userDataBloc.userData.completedLevels >=
              levelBloc.level.number) {
            // somar as moedas ganhas do usuario e leva-lo para o menu de leveis
            timer = Timer(const Duration(seconds: 1), () {
              userDataBloc.userData.coins =
                  userDataBloc.userData.coins + levelBloc.levelCoins;
              userDataBloc.add(const UpdateUserData());
              Modular.to.navigate('../');
            });
          } // Se o usuario não tiver completado esse level antes,
          // Ele é levado para a tela de premiação
          else {
            timer = Timer(const Duration(seconds: 1), () {
              Modular.to.navigate('./Reward');
            });
          }

          // showDialog que aparece quando acaba o timer do levelBloc
          showDialog(
            barrierColor: const Color.fromARGB(40, 0, 0, 0),
            barrierDismissible: false,
            context: context,
            builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Widget com o texto
                Material(
                  color: Colors.transparent,
                  // TODO(YuriOliv): no momento está como um texto,
                  //  mas acho que é uma imagem, fora isso o texto
                  //  parece ficar muito escuro, verificar
                  child: Text(
                    BrazilianPortuguese().timeOver,
                    style: AppTypography.font28BoldColor(),
                  ),
                ),
                // Passa para a proxima questão
              ],
            ),
          );
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    timerToAnswerQuestion?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // Retorna a tela
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Column da imagem mostrando o menu dentro da fase
          PagesBackground(
              mediaQuery: mediaQuery,
              localImagem: 'assets/images/green-mountains-background.png'),
          // Column da imagem mostrando o menu dentro da fase
          Column(
            children: <Widget>[
              SizedBox(height: mediaQuery.size.height * 0.05),
              // Imagem mostrando o menu dentro da fase
              Row(
                children: [
                  SizedBox(width: mediaQuery.size.width * 0.07),
                  boxMenu(mediaQuery),
                  // Botão "fechar", fecha a FaseView e volta para a GameView
                  buttonClose(mediaQuery),
                ],
              ),
            ],
          ),
          // TODO(YuriOliv): Zoom ao clicar na pergunta
          // Column do fundo para mostrar a pergunta
          Column(
            children: <Widget>[
              SizedBox(height: mediaQuery.size.height * 0.15),
              // Fundo para mostrar a pergunta
              GestureDetector(
                  onTap: () {
                    Modular.to.navigate('./Question');
                    levelBloc.isTimeActive = true;
                  },
                  child: questionBox(mediaQuery)),

              // Fundo da opção de resposta 1
              AnswerOptionButton(
                mediaQuery: mediaQuery,
                verticalSize: 0.09,
                horizontalSize: 0.82,
                correctAnswerOptionNumber: levelBloc
                    .level.questions[levelBloc.actualQuestion].answerIndex,
                actualAnswerOptionNumber: levelBloc.orderAnswers[0],
              ),
              // Espaço entre opções de resposta
              SizedBox(height: mediaQuery.size.height * 0.01),
              // Fundo da opção de resposta 2
              AnswerOptionButton(
                mediaQuery: mediaQuery,
                verticalSize: 0.09,
                horizontalSize: 0.82,
                correctAnswerOptionNumber: levelBloc
                    .level.questions[levelBloc.actualQuestion].answerIndex,
                actualAnswerOptionNumber: levelBloc.orderAnswers[1],
              ),
              // Espaço entre opções de resposta
              SizedBox(height: mediaQuery.size.height * 0.01),
              // Fundo da opção de resposta 3
              AnswerOptionButton(
                mediaQuery: mediaQuery,
                verticalSize: 0.09,
                horizontalSize: 0.82,
                correctAnswerOptionNumber: levelBloc
                    .level.questions[levelBloc.actualQuestion].answerIndex,
                actualAnswerOptionNumber: levelBloc.orderAnswers[2],
              ),
              // Espaço entre opções de resposta
              SizedBox(height: mediaQuery.size.height * 0.01),
              // Fundo da opção de resposta 4
              AnswerOptionButton(
                mediaQuery: mediaQuery,
                verticalSize: 0.09,
                horizontalSize: 0.82,
                correctAnswerOptionNumber: levelBloc
                    .level.questions[levelBloc.actualQuestion].answerIndex,
                actualAnswerOptionNumber: levelBloc.orderAnswers[3],
              ),
            ],
          ),
          // Column de Botões de ajuda
          //
          // TODO(YuriOliv): Bloqueado caso não aja dinheiro suficiente (if's)
          Column(
            children: [
              SizedBox(height: mediaQuery.size.height * 0.88),
              Row(
                children: [
                  // Botão dica
                  buttonTip(mediaQuery),

                  // Botão pular
                  buttonSkip(mediaQuery),

                  // Botão adicionar tempo
                  buttonMoreTime(mediaQuery),

                  // Botão eliminar item
                  buttonDelete(mediaQuery),
                ],
              ),
            ],
          ),
          // Este BlocBuilder devolve o texto da pergunta e o texto "acertou"
          // ou "errou" dependendo da escolha de opção de resposta do usuario
          BlocBuilder<LevelBloc, AppState>(
              bloc: levelBloc,
              builder: (context, state) {
                if (state is InitialState || state is UpdatingActualQuestion) {
                  return const SizedBox();
                }

                // Apos o usuario responder a pergunta,
                // é feita a adição das moedas caso, tenha acertado
                if (state is SuccessfullyUpdateIsAnswerOptionSelected) {
                  // Verifica se acertou a questão e adiciona as moedas ganhas
                  // Executada apenas uma vez
                  levelBloc.add(const CorrectQuestionCoinsIncrease());
                }

                // Verificadores condicionais para mudança de tela
                // Apos o usuario ter selecionado uma opção de resposta
                if (state is SucessfullyIncreasedQuestionCoins) {
                  // Caso o usuario não tenha completado todas as
                  // questões do level
                  if (levelBloc.auxQuestionNumber <
                      levelBloc.level.questionsToComplete) {
                    timer = Timer(const Duration(seconds: 3), () {
                      Modular.to.navigate('./Question');
                    });
                  } // Caso o usuario ja tiver completado todas as questões
                  else {
                    // Para se o usuario ja tiver concluido este level antes
                    if (userDataBloc.userData.completedLevels >=
                        levelBloc.level.number) {
                      // Espera 3 segundos para somar as moedas ganhas
                      // E leva-lo para o menu de leveis
                      timer = Timer(const Duration(seconds: 3), () {
                        userDataBloc.userData.coins =
                            userDataBloc.userData.coins + levelBloc.levelCoins;
                        userDataBloc.add(const UpdateUserData());
                        Modular.to.navigate('../');
                      });
                    } // Se não acertar todas as questões ou não acertar nenhuma
                    else if (levelBloc.correctQuestions == 0 ||
                        levelBloc.correctQuestions <
                            levelBloc.level.questionsToComplete) {
                      timer = Timer(const Duration(seconds: 3), () {
                        Modular.to.navigate('./Reward');
                      });
                    } // Se usuario acertar todas as questões e passar de fase
                    else {
                      timer = Timer(const Duration(seconds: 3), () {
                        Modular.to.navigate('./Congratulations');
                      });
                    }
                  }
                }

                // Retorna um linha com o texto da pergunta e o texto "acertou"
                // ou "errou" dependendo da escolha de resposta do usuario
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        // Retorna o texto "acertou" ou "errou"
                        Column(
                          children: [
                            // Espaço do topo da tela ate o inicio do SizedBox
                            // com o texto da pergunta atual
                            SizedBox(height: mediaQuery.size.height * 0.18),
                            SizedBox(
                              width: mediaQuery.size.width * 0.7,
                              height: mediaQuery.size.height * 0.03,
                              child: Text(
                                !levelBloc.isAnswerOptionSelected
                                    ? ''
                                    : levelBloc
                                                .level
                                                .questions[
                                                    levelBloc.actualQuestion]
                                                .answerIndex ==
                                            levelBloc.optionSelected
                                        ? BrazilianPortuguese().right
                                        : BrazilianPortuguese().wrong,
                                style: AppTypography().font24BoldSelect(levelBloc),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        // Retorna o texto da pergunta
                        Column(
                          children: [
                            // Espaço do topo da tela ate o inicio do SizedBox
                            // com o texto da pergunta atual
                            SizedBox(height: mediaQuery.size.height * 0.21),
                            // SizedBox com o texto da pergunta atual
                            SizedBox(
                              width: mediaQuery.size.width * 0.7,
                              height: mediaQuery.size.height * 0.22,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Texto da pergunta atual,
                                  // TODO(YuriOliv): criar função para adaptar o
                                  //  tamanho do texto da pergunta? se o texto
                                  //  for muito grande o resto da
                                  //  pergunta não aparece
                                  Text(
                                    levelBloc
                                        .level
                                        .questions[levelBloc.actualQuestion]
                                        .question,
                                    style: AppTypography.font16Bold(),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }),
          // Dados na parte superior da tela, necessario usar
          // dois BlocBuilder pois são utilizados dados de 2 blocs
          BlocBuilder<UserDataBloc, AppState>(
            bloc: userDataBloc,
            builder: (context, state1) {
              if (state1 is InitialState || state1 is UpdatingActualQuestion) {
                return const SizedBox();
              }
              return BlocBuilder<LevelBloc, AppState>(
                bloc: levelBloc,
                builder: (context, state2) {
                  if (state2 is InitialState ||
                      state2 is UpdatingActualQuestion) {
                    return const SizedBox();
                  }
                  return Column(
                    children: <Widget>[
                      // Espaço entre o widget e o topo da tela
                      SizedBox(height: mediaQuery.size.height * 0.0695),
                      Row(
                        children: <Widget>[
                          // Espaço entre o widget e o lado esquerdo da tela
                          SizedBox(width: mediaQuery.size.width * 0.21),
                          // 1° dado, valor de dinheiro ja guardado em Save
                          SizedBox(
                            width: mediaQuery.size.width * 0.12,
                            height: mediaQuery.size.height * 0.02,
                            child: Text(
                              levelBloc.levelCoins.toString(),
                              style: AppTypography.font14Bold(),
                            ),
                          ),
                          // Espaço entre o widget e o lado esquerdo da tela
                          SizedBox(width: mediaQuery.size.width * 0.16),
                          // 2° dado, nivel atual
                          SizedBox(
                            width: mediaQuery.size.width * 0.15,
                            height: mediaQuery.size.height * 0.02,
                            child: Text(
                              BrazilianPortuguese()
                                  .actualLevel(levelBloc.actualLevel),
                              style: AppTypography.font14Bold(),
                            ),
                          ),
                        ],
                      ),
                      // Espaço entre o widget e o topo da tela
                      SizedBox(height: mediaQuery.size.height * 0.035),
                      Row(
                        children: <Widget>[
                          // Espaço entre o widget e o lado esquerdo da tela
                          SizedBox(width: mediaQuery.size.width * 0.21),
                          // 3° dado, valor de dinheiro ja guardado em Save
                          SizedBox(
                            width: mediaQuery.size.width * 0.12,
                            height: mediaQuery.size.height * 0.02,
                            child: Text(
                              userDataBloc.userData.coins.toString(),
                              style: AppTypography.font14Bold(),
                            ),
                          ),
                          // Espaço entre o widget e o lado esquerdo da tela
                          SizedBox(width: mediaQuery.size.width * 0.18),
                          // 4° dado
                          // Timer limite ate a questão ser dada como errada
                          SizedBox(
                            width: mediaQuery.size.width * 0.12,
                            height: mediaQuery.size.height * 0.02,
                            child: Text(
                              levelBloc.timerToAnswer.toString(),
                              style: AppTypography.font14Bold(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget questionBox(MediaQueryData mediaQuery) {
    return Row(
      children: [
        SizedBox(width: mediaQuery.size.width * 0.07),
        SizedBox(
          height: mediaQuery.size.height * 0.32,
          width: mediaQuery.size.width * 0.86,
          child: Image.asset(
            'assets/images/white-box-background.png',
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }

  Widget boxMenu(MediaQueryData mediaQuery) {
    return SizedBox(
      height: mediaQuery.size.height * 0.11,
      width: mediaQuery.size.width * 0.58,
      child: Image.asset(
        'assets/images/level-stats-box-background.png',
        fit: BoxFit.fill,
      ),
    );
  }

  Widget buttonClose(MediaQueryData mediaQuery) {
    return GestureDetector(
      // Caso o usuario ja tenha ganho alguma moeda
      // Sera avisado que suas moedas serão guardadas (tela)
      onTap: () {
        levelBloc.levelCoins > 0
            ? Modular.to.navigate('./LevelClosingWithEarnedCoins')
            : Modular.to.navigate('../');
      },
      child: Row(
        children: [
          SizedBox(width: mediaQuery.size.width * 0.14),
          SizedBox(
            height: mediaQuery.size.height * 0.08,
            width: mediaQuery.size.width * 0.16,
            child: Image.asset(
              'assets/images/button-close.png',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonTip(MediaQueryData mediaQuery) {
    return GestureDetector(
      onTap: () {}, // TODO(YuriOliv): Criar função de dica
      child: Row(
        children: [
          SizedBox(width: mediaQuery.size.width * 0.07),
          SizedBox(
            height: mediaQuery.size.height * 0.10,
            width: mediaQuery.size.width * 0.18,
            child: Image.asset(
              'assets/images/help-button-tip.png',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonSkip(MediaQueryData mediaQuery) {
    return GestureDetector(
      // TODO(YuriOliv): Criar função para pular pergunta
      onTap: () {},
      child: Row(
        children: [
          SizedBox(width: mediaQuery.size.width * 0.05),
          SizedBox(
            height: mediaQuery.size.height * 0.10,
            width: mediaQuery.size.width * 0.18,
            child: Image.asset(
              'assets/images/help-button-skip.png',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonMoreTime(MediaQueryData mediaQuery) {
    return GestureDetector(
      // TODO(YuriOliv): Criar função para adicionar tempo
      // no contador
      onTap: () {},
      child: Row(
        children: [
          SizedBox(width: mediaQuery.size.width * 0.05),
          SizedBox(
            height: mediaQuery.size.height * 0.10,
            width: mediaQuery.size.width * 0.18,
            child: Image.asset(
              'assets/images/help-button-more-time.png',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonDelete(MediaQueryData mediaQuery) {
    return GestureDetector(
      // TODO(YuriOliv): Criar função para eliminar item
      onTap: () {},
      child: Row(
        children: [
          SizedBox(width: mediaQuery.size.width * 0.05),
          SizedBox(
            height: mediaQuery.size.height * 0.10,
            width: mediaQuery.size.width * 0.18,
            child: Image.asset(
              'assets/images/help-button-delete.png',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
