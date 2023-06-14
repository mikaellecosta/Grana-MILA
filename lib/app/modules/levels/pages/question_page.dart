import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_bloc.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_events.dart';
import 'package:lasic_grana_flutter/app/core/languages/brazilian_portuguese.dart';
import 'package:lasic_grana_flutter/app/core/widgets/pages_background.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_bloc.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_events.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_states.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  _QuestionPageState();

  final levelBloc = Modular.get<LevelBloc>();
  final userDataBloc = Modular.get<UserDataBloc>();
  Timer? timer;
  Timer? timerToAnswerQuestion;

  @override
  void initState() {
    // TODO(YuriOliv): Resolver bug no Timer ao minimizar e voltar.
    // Timer ate a resposta ser dada como errada e passar para a proxima

    timerToAnswerQuestion = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!levelBloc.isAnswerOptionSelected) {
        if (levelBloc.isTimeActive == false) {
          timer?.cancel();
          timerToAnswerQuestion?.cancel();
        } else if (levelBloc.timerToAnswer > 0) {
          levelBloc.add(const ReduceTimer());
        } else {
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
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 0, 0),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
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
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Column da imagem mostrando o menu dentro da fase
          PagesBackground(
              mediaQuery: mediaQuery,
              localImagem: 'assets/images/green-mountains-background.png'),
          Column(
            children: <Widget>[
              SizedBox(height: mediaQuery.size.height * 0.05),
              // Imagem mostrando o menu dentro da fase
              Row(
                children: [
                  SizedBox(width: mediaQuery.size.width * 0.07),
                  SizedBox(
                    height: mediaQuery.size.height * 0.11,
                    width: mediaQuery.size.width * 0.58,
                    child: Image.asset(
                      'assets/images/level-stats-box-background.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  // Botão "fechar", fecha a FaseView e volta para a GameView
                  GestureDetector(
                    // Caso o usuario ja tenha ganho alguma moeda
                    // Sera levado a tela que avisa: Suas moedas serão guardadas
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
                  ),
                ],
              ),
            ],
          ),
          // Column do fundo da pergunta
          Column(
            children: <Widget>[
              SizedBox(height: mediaQuery.size.height * 0.185),
              // Fundo da pergunta
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: mediaQuery.size.height * 0.64,
                    width: mediaQuery.size.width * 0.86,
                    child: Image.asset(
                      'assets/images/white-box-background.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Column do botão que manda o usuario da tela de pergunta para tela
          // com opções de resposta
          BlocBuilder<LevelBloc, AppState>(
              // mudar estado entre botao e dicas
              bloc: levelBloc,
              builder: (context, state) {
                // Botão que manda o usuario da tela de pergunta para tela
                // com opções de resposta
                bool expandedQuestion;
                
                if (levelBloc.isTimeActive == false){
                  expandedQuestion = false;
                } else {
                  expandedQuestion = true;
                }

                if (expandedQuestion == false) {
                  return GestureDetector(
                    onTap: () => {
                      Modular.to.navigate('./AnswerOptions'),
                      levelBloc.isTimeActive = false
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(height: mediaQuery.size.height * 0.85),
                        Container(
                          height: mediaQuery.size.height * 0.11,
                          width: mediaQuery.size.width * 0.55,
                          margin: EdgeInsets.only(
                              left: mediaQuery.size.width * 0.2),
                          child: Image.asset(
                            'assets/images/answer-button.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Column(children: [
                    SizedBox(height: mediaQuery.size.height * 0.73),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Modular.to.navigate('./AnswerOptions');
                            levelBloc.isTimeActive = false;
                          },
                          child: Row(
                            children: [
                              SizedBox(width: mediaQuery.size.width * 0.14),
                              Container(
                                // color: Colors.amber,
                                margin: EdgeInsets.only(
                                    left: mediaQuery.size.width * 0.58,
                                    bottom: mediaQuery.size.width * 0.07),
                                height: mediaQuery.size.height * 0.08,
                                width: mediaQuery.size.width * 0.16,
                                child: Image.asset(
                                  'assets/images/button-close.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
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
                  ]);
                }
              }),

          // Mostra o texto da pergunta
          BlocBuilder<LevelBloc, AppState>(
              bloc: levelBloc,
              builder: (context, state) {
                if (state is InitialState || state is UpdatingActualQuestion) {
                  return const SizedBox();
                }

                // Atualiza a questão quando a questão passada ja foi resolvida,
                // essa acabou sendo a menor maneira de trocar a questão pois
                // nas outras testadas o usuario podia perceber
                // as frases sendo mudadas
                if (state is SucessfullyIncreasedQuestionCoins) {
                  levelBloc.add(const UpdateActualQuestion());
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: mediaQuery.size.height * 0.5,
                          width: mediaQuery.size.width * 0.7,
                          child: Center(
                            child: Text(
                              levelBloc.level
                                  .questions[levelBloc.actualQuestion].question,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
          // Dados na parte superior da tela
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
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
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
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
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
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          // 4° dado, timer vazio na pergunta

                          Container(
                            width: mediaQuery.size.width * 0.12,
                            height: mediaQuery.size.height * 0.02,
                            padding: EdgeInsets.only(
                                left: mediaQuery.size.width * 0.06),
                            margin: EdgeInsets.only(
                                left: mediaQuery.size.width * 0.12),
                            child: Text(
                              levelBloc.timerToAnswer.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
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

  Widget buttonTip(MediaQueryData mediaQuery) {
    return GestureDetector(
      onTap: () {
        levelBloc.isTimeActive = false;
      }, // TODO(YuriOliv): Criar função de dica
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
      onTap: () {
        levelBloc.isTimeActive = false;
      },
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
      onTap: () {
        levelBloc.isTimeActive = false;
      },
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
      onTap: () {
        levelBloc.isTimeActive = false;
      },
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
