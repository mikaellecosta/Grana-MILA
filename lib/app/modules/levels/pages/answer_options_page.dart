import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_bloc.dart';
import 'package:lasic_grana_flutter/app/core/languages/brazilian_portuguese.dart';
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
  final _levelBloc = Modular.get<LevelBloc>();
  final _userDataBloc = Modular.get<UserDataBloc>();

  Timer? _timer;
  Timer? _timerToAnswerQuestion;
  bool _isTimeStop = false;

  bool _alreadyTapOnButtonTip = false;

  @override
  void initState() {
    _levelBloc.optionSelected = -1;

    // Timer ate a resposta ser dada como errada e passar para a proxima
    _timerToAnswerQuestion = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_levelBloc.isAnswerOptionSelected) {
        if (_levelBloc.isTimeActive == true) {
          _timer?.cancel();
          _timerToAnswerQuestion?.cancel();
        } else if (_levelBloc.timerToAnswer > 0) {
          if (!_isTimeStop) {
            _levelBloc.add(const ReduceTimer());
          }
        } else {
          // É necessario para o timerToAnswerQuestion
          _timerToAnswerQuestion?.cancel();
          // Função que verifica o acerto da questão e adiciona as moedas
          // Colocar aqui pois ela é necessaria para passar de questão
          _levelBloc.add(const CorrectQuestionCoinsIncrease());
          // Inicia um timer para passar para proxima tela
          // Passa para a proxima questão, até o fim da quantidade de
          // questões do level
          if (_levelBloc.answeredQuestions <
              _levelBloc.level.questionsToComplete - 1) {
            _timer = Timer(const Duration(seconds: 1), () {
              Modular.to.navigate('./Question');
            });
          }
          // Se o usuario ja tiver completado esse level antes,
          // Ele é mandado para o menu de leveis
          else if (_userDataBloc.userData.completedLevels >=
              _levelBloc.level.number) {
            // leva-lo para o menu de leveis
            _timer = Timer(const Duration(seconds: 1), () {
              Modular.to.navigate('../');
            });
          } // Se o usuario não tiver completado esse level antes,
          // Ele é levado para a tela de premiação
          else {
            _timer = Timer(const Duration(seconds: 1), () {
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
    _timer?.cancel();
    _timerToAnswerQuestion?.cancel();
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
                  _boxMenu(mediaQuery),
                  SizedBox(width: mediaQuery.size.width * 0.14),
                  // Botão "fechar", fecha a FaseView e volta para a GameView
                  _closeButton(mediaQuery),
                ],
              ),
            ],
          ),
          // Column do fundo para mostrar a pergunta
          Column(
            children: <Widget>[
              SizedBox(height: mediaQuery.size.height * 0.15),
              // Fundo para mostrar a pergunta
              GestureDetector(
                  onTap: () {
                    Modular.to.navigate('./Question');
                    _levelBloc.isTimeActive = true;
                  },
                  child: _questionBox(mediaQuery)),

              // Fundo da opção de resposta 1
              BlocBuilder(
                  bloc: _levelBloc,
                  builder: (context, state) {
                    return Column(
                      children: [
                        AnswerOptionButton(
                          mediaQuery: mediaQuery,
                          verticalSize: 0.09,
                          horizontalSize: 0.82,
                          correctAnswerOptionNumber: _levelBloc.level
                              .questions[_levelBloc.actualQuestion].answerIndex,
                          actualAnswerOptionNumber: _levelBloc.orderAnswers[0],
                        ),
                        // Espaço entre opções de resposta
                        SizedBox(height: mediaQuery.size.height * 0.01),
                        // Fundo da opção de resposta 2
                        AnswerOptionButton(
                          mediaQuery: mediaQuery,
                          verticalSize: 0.09,
                          horizontalSize: 0.82,
                          correctAnswerOptionNumber: _levelBloc.level
                              .questions[_levelBloc.actualQuestion].answerIndex,
                          actualAnswerOptionNumber: _levelBloc.orderAnswers[1],
                        ),
                        // Espaço entre opções de resposta
                        SizedBox(height: mediaQuery.size.height * 0.01),
                        // Fundo da opção de resposta 3
                        AnswerOptionButton(
                          mediaQuery: mediaQuery,
                          verticalSize: 0.09,
                          horizontalSize: 0.82,
                          correctAnswerOptionNumber: _levelBloc.level
                              .questions[_levelBloc.actualQuestion].answerIndex,
                          actualAnswerOptionNumber: _levelBloc.orderAnswers[2],
                        ),
                        // Espaço entre opções de resposta
                        SizedBox(height: mediaQuery.size.height * 0.01),
                        // Fundo da opção de resposta 4
                        AnswerOptionButton(
                          mediaQuery: mediaQuery,
                          verticalSize: 0.09,
                          horizontalSize: 0.82,
                          correctAnswerOptionNumber: _levelBloc.level
                              .questions[_levelBloc.actualQuestion].answerIndex,
                          actualAnswerOptionNumber: _levelBloc.orderAnswers[3],
                        ),
                      ],
                    );
                  }),
            ],
          ),
          // Column de Botões de ajuda
          // Esse block atualiza os botões de ajuda para estados de habilitado
          // e desabilitado
          BlocBuilder<LevelBloc, AppState>(
              bloc: _levelBloc,
              builder: (context, state) {
                final int levelCoins = _levelBloc.levelCoins;
                final int bankCoins = _userDataBloc.userData.coins;

                if (state is SucessfullySkipQuestion) {
                  _levelBloc.add(const CorrectQuestionCoinsIncrease());
                  Modular.to.navigate('./Question');
                }

                // Botões bloqueados se dinheiro menor que cinquenta
                if (levelCoins < 50 && bankCoins < 50) {
                  return Column(
                    children: [
                      SizedBox(height: mediaQuery.size.height * 0.88),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Botão dica
                          _blocButton(
                              mediaQuery, 'assets/images/help-button-tip'),
                          // Botão pular
                          _blocButton(
                              mediaQuery, 'assets/images/help-button-skip'),
                          // Botão adicionar tempo
                          _blocButton(mediaQuery,
                              'assets/images/help-button-more-time'),
                          // Botão eliminar item
                          _blocButton(
                              mediaQuery, 'assets/images/help-button-delete'),
                        ],
                      ),
                    ],
                  );
                }
                // Botões de Dica e Pular bloqueados se dinheiro menor que cem
                if (levelCoins < 100 && bankCoins < 100) {
                  return Column(
                    children: [
                      SizedBox(height: mediaQuery.size.height * 0.88),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Botão dica
                          _blocButton(
                              mediaQuery, 'assets/images/help-button-tip'),
                          // Botão pular
                          _blocButton(
                              mediaQuery, 'assets/images/help-button-skip'),
                          // Botão adicionar tempo
                          _moreTimeButton(mediaQuery),
                          // Botão eliminar item
                          _eliminateButton(mediaQuery),
                        ],
                      ),
                    ],
                  );
                }
                // Botões desbloqueados se dinheiro maior ou igual a 100
                return Column(
                  children: [
                    SizedBox(height: mediaQuery.size.height * 0.88),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Botão dica
                        _tipButton(mediaQuery),
                        // Botão pular
                        _skipButton(mediaQuery),
                        // Botão adicionar tempo
                        _moreTimeButton(mediaQuery),
                        // Botão eliminar item
                        _eliminateButton(mediaQuery),
                      ],
                    ),
                  ],
                );
              }),
          // Este BlocBuilder devolve o texto da pergunta e o texto "acertou"
          // ou "errou" dependendo da escolha de opção de resposta do usuario
          BlocBuilder<LevelBloc, AppState>(
              bloc: _levelBloc,
              builder: (context, state) {
                if (state is InitialState || state is UpdatingActualQuestion) {
                  return const SizedBox();
                }

                // Apos o usuario responder a pergunta,
                // é feita a adição das moedas caso, tenha acertado
                if (state is SuccessfullyUpdateIsAnswerOptionSelected) {
                  // Verifica se acertou a questão e adiciona as moedas ganhas
                  // Executada apenas uma vez
                  _levelBloc.add(const CorrectQuestionCoinsIncrease());
                }

                // Verificadores condicionais para mudança de tela
                // Apos o usuario ter selecionado uma opção de resposta
                if (state is SucessfullyIncreasedQuestionCoins) {
                  // Caso o usuario não tenha completado todas as
                  // questões do level
                  if (_levelBloc.answeredQuestions <
                      _levelBloc.level.questionsToComplete) {
                    _timer = Timer(const Duration(seconds: 3), () {
                      Modular.to.navigate('./Question');
                    });
                  } // Caso o usuario ja tiver completado todas as questões
                  else {
                    // Para se o usuario ja tiver concluido este level antes
                    if (_userDataBloc.userData.completedLevels >=
                        _levelBloc.level.number) {
                      // Espera 3 segundos para leva-lo para o menu de leveis
                      _timer = Timer(const Duration(seconds: 3), () {
                        Modular.to.navigate('../');
                      });
                    } // Se não acertar todas as questões ou não acertar nenhuma
                    else if (_levelBloc.correctQuestions == 0 ||
                        _levelBloc.correctQuestions <
                            _levelBloc.level.questionsToComplete) {
                      _timer = Timer(const Duration(seconds: 3), () {
                        Modular.to.navigate('./Reward');
                      });
                    } // Se usuario acertar todas as questões e passar de fase
                    else {
                      _timer = Timer(const Duration(seconds: 3), () {
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
                                !_levelBloc.isAnswerOptionSelected
                                    ? ''
                                    : _levelBloc
                                                .level
                                                .questions[
                                                    _levelBloc.actualQuestion]
                                                .answerIndex ==
                                            _levelBloc.optionSelected
                                        ? BrazilianPortuguese().right
                                        : BrazilianPortuguese().wrong,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: _levelBloc
                                              .level
                                              .questions[
                                                  _levelBloc.actualQuestion]
                                              .answerIndex ==
                                          _levelBloc.optionSelected
                                      ? Colors.green
                                      : Colors.red,
                                ),
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
                                  Text(
                                    _levelBloc
                                        .level
                                        .questions[_levelBloc.actualQuestion]
                                        .question,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
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
            bloc: _userDataBloc,
            builder: (context, state1) {
              if (state1 is InitialState || state1 is UpdatingActualQuestion) {
                return const SizedBox();
              }
              return BlocBuilder<LevelBloc, AppState>(
                bloc: _levelBloc,
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
                              _levelBloc.levelCoins.toString(),
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
                                  .actualLevel(_levelBloc.actualLevel),
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
                              _userDataBloc.userData.coins.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
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
                              _levelBloc.timerToAnswer.toString(),
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

  Widget _questionBox(MediaQueryData mediaQuery) {
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

  Widget _boxMenu(MediaQueryData mediaQuery) {
    return SizedBox(
      height: mediaQuery.size.height * 0.11,
      width: mediaQuery.size.width * 0.58,
      child: Image.asset(
        'assets/images/level-stats-box-background.png',
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _closeButton(MediaQueryData mediaQuery) {
    return GestureDetector(
      // Caso o usuario ja tenha ganho alguma moeda
      // Sera avisado que suas moedas serão guardadas (tela)
      onTap: () {
        _levelBloc.levelCoins > 0
            ? Modular.to.navigate('./LevelClosingWithEarnedCoins')
            : Modular.to.navigate('../');
      },
      child: SizedBox(
        height: mediaQuery.size.height * 0.08,
        width: mediaQuery.size.width * 0.16,
        child: Image.asset(
          'assets/images/button-close.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  // Botão de dica
  Widget _tipButton(MediaQueryData mediaQuery) {
    // Só é permitido uma dica por questão (botão bloqueia)
    if (_alreadyTapOnButtonTip) {
      return _blocButton(mediaQuery, 'assets/images/help-button-tip');
    }

    return GestureDetector(
      onTap: () {
        _isTimeStop = true;
        // Se tiver conseguido dinheiro no questionario em andamento
        if (_levelBloc.levelCoins >= 100) {
          _yesNoDialogBox(
            mediaQuery,
            tittle: BrazilianPortuguese().tip,
            informationText: BrazilianPortuguese().seeTip,
            value: 100,
            function: () {
              _okDialogBox(
                mediaQuery,
                tittle: BrazilianPortuguese().tip,
                informationText:
                    _levelBloc.level.questions[_levelBloc.actualQuestion].tip,
              );
              _alreadyTapOnButtonTip = true;
            },
          );
        }
        // Se não, tirar do banco
        else {
          _yesNoDialogBox(
            mediaQuery,
            tittle: BrazilianPortuguese().attention,
            informationText: BrazilianPortuguese().takeBankCoin,
            value: 100,
            function: () {
              _okDialogBox(
                mediaQuery,
                tittle: BrazilianPortuguese().tip,
                informationText:
                    _levelBloc.level.questions[_levelBloc.actualQuestion].tip,
              );
              _alreadyTapOnButtonTip = true;
            },
          );
        }
      },
      child: SizedBox(
        height: mediaQuery.size.height * 0.10,
        width: mediaQuery.size.width * 0.18,
        child: Image.asset(
          'assets/images/help-button-tip.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  // Botão de pular questão
  Widget _skipButton(MediaQueryData mediaQuery) {
    // Botão é bloqueado se tiver pulado a questão anterior
    // ou for a última questão
    if (_levelBloc.isPreviousQuestionSkipped ||
        _levelBloc.auxQuestionNumber == _levelBloc.level.totalQuestions - 1) {
      return _blocButton(mediaQuery, 'assets/images/help-button-skip');
    }
    return GestureDetector(
      onTap: () {
        _isTimeStop = true;
        // Se tiver conseguido dinheiro no questionario em andamento
        if (_levelBloc.levelCoins >= 100) {
          _yesNoDialogBox(
            mediaQuery,
            tittle: BrazilianPortuguese().skip,
            informationText: BrazilianPortuguese().skipQuestion,
            value: 100,
            function: () {
              _isTimeStop = false;
              // _levelBloc.isPreviousQuestionSkipped = true;
              // _levelBloc.add(const CorrectQuestionCoinsIncrease());
              _levelBloc.add(const SkipQuestion());
            },
          );
        }
        // Se não, tirar do banco
        else {
          _yesNoDialogBox(
            mediaQuery,
            tittle: BrazilianPortuguese().attention,
            informationText: BrazilianPortuguese().takeBankCoin,
            value: 100,
            function: () {
              _isTimeStop = false;
              // _levelBloc.isPreviousQuestionSkipped = true;
              // _levelBloc.add(const CorrectQuestionCoinsIncrease());
              _levelBloc.add(const SkipQuestion());
            },
          );
        }
      },
      child: SizedBox(
        height: mediaQuery.size.height * 0.10,
        width: mediaQuery.size.width * 0.18,
        child: Image.asset(
          'assets/images/help-button-skip.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  // Botão de adicinar 15 segundos no tempo de resposta
  Widget _moreTimeButton(MediaQueryData mediaQuery) {
    return GestureDetector(
      onTap: () {
        _isTimeStop = true;
        // Se tiver conseguido dinheiro no questionario em andamento
        if (_levelBloc.levelCoins >= 50) {
          _yesNoDialogBox(
            mediaQuery,
            tittle: BrazilianPortuguese().moreTime,
            informationText: BrazilianPortuguese().moreFifteenSeconds,
            value: 50,
            function: () {
              _isTimeStop = false;
              _levelBloc.timerToAnswer += 15;
            },
          );
        }
        // Se não, tirar do banco
        else {
          _yesNoDialogBox(
            mediaQuery,
            tittle: BrazilianPortuguese().attention,
            informationText: BrazilianPortuguese().takeBankCoin,
            value: 50,
            function: () {
              _isTimeStop = false;
              _levelBloc.timerToAnswer += 15;
            },
          );
        }
      },
      child: SizedBox(
        height: mediaQuery.size.height * 0.10,
        width: mediaQuery.size.width * 0.18,
        child: Image.asset(
          'assets/images/help-button-more-time.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  // Botão para elimitar uma opção de resposta errada
  Widget _eliminateButton(MediaQueryData mediaQuery) {
    // Butão bloqueia se sobrar só uma opção de resposta
    if (_levelBloc.level.totalQuestions ==
        _levelBloc.eliminatedAnswers.length + 1) {
      return _blocButton(mediaQuery, 'assets/images/help-button-delete');
    }
    return GestureDetector(
      onTap: () {
        _isTimeStop = true;
        // Se tiver conseguido dinheiro no questionario em andamento
        if (_levelBloc.levelCoins >= 50) {
          _yesNoDialogBox(
            mediaQuery,
            tittle: BrazilianPortuguese().scissors,
            informationText: BrazilianPortuguese().eliminateAnswer,
            value: 50,
            function: () {
              _isTimeStop = false;
              _levelBloc.add(const EliminateAnswerOption());
            },
          );
        }
        // Se não, tirar do banco
        else {
          _yesNoDialogBox(
            mediaQuery,
            tittle: BrazilianPortuguese().attention,
            informationText: BrazilianPortuguese().takeBankCoin,
            value: 50,
            function: () {
              _isTimeStop = false;
              _levelBloc.add(const EliminateAnswerOption());
            },
          );
        }
      },
      child: SizedBox(
        height: mediaQuery.size.height * 0.10,
        width: mediaQuery.size.width * 0.18,
        child: Image.asset(
          'assets/images/help-button-delete.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  // Botão de ajuda bloquedo
  Widget _blocButton(MediaQueryData mediaQuery, String image) {
    return GestureDetector(
      onTap: () {
        _isTimeStop = true;
        _okDialogBox(
          mediaQuery,
          tittle: BrazilianPortuguese().alert,
          informationText: BrazilianPortuguese().cantBuyHelp,
        );
      },
      child: SizedBox(
        height: mediaQuery.size.height * 0.10,
        width: mediaQuery.size.width * 0.18,
        child: Image.asset(
          '$image-locked.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  // Popup com botão de OK
  Future _okDialogBox(MediaQueryData mediaQuery,
      {required String tittle, required String informationText}) {
    return showDialog(
      context: context,
      builder: (context) => Stack(
        children: <Widget>[
          _whiteBoxForAlertDialog(mediaQuery),
          _alertTittle(mediaQuery, tittle),
          _alertInformation(mediaQuery, informationText),
          _exitAlertOkButton(mediaQuery),
        ],
      ),
    );
  }

  // Popup com botão de SIM e NÃO
  Future _yesNoDialogBox(MediaQueryData mediaQuery,
      {required String tittle,
      required String informationText,
      required int value,
      required function}) {
    return showDialog(
      context: context,
      builder: (context) => Stack(
        children: <Widget>[
          _whiteBoxForAlertDialog(mediaQuery),
          _alertTittle(mediaQuery, tittle),
          _alertInformation(mediaQuery, informationText),
          _exitAlertYesNoButton(mediaQuery, value, function),
        ],
      ),
    );
  }

  // Fundo do popup
  Widget _whiteBoxForAlertDialog(MediaQueryData mediaQuery) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.03),
          child: Image.asset('assets/images/white-box-background.png'),
        ),
      ],
    );
  }

  // Titulo do popup
  Widget _alertTittle(MediaQueryData mediaQuery, String tittle) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Column(children: [
        SizedBox(
          height: mediaQuery.size.height * 0.39,
        ),
        Material(
            color: Colors.transparent,
            child: Text(
              tittle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ))
      ])
    ]);
  }

  // Texto do popup
  Widget _alertInformation(MediaQueryData mediaQuery, String informationText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.1),
      child: Column(
        children: [
          SizedBox(
            height: mediaQuery.size.height * 0.47,
          ),
          Material(
            color: Colors.transparent,
            child: Column(
              children: [
                SizedBox(
                  width: mediaQuery.size.width,
                  child: Text(
                    informationText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Botão de OK do popup
  Widget _exitAlertOkButton(MediaQueryData mediaQuery) {
    return Column(
      children: [
        SizedBox(
          height: mediaQuery.size.height * 0.58,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Botão (OK)
            GestureDetector(
                onTap: () {
                  _isTimeStop = false;
                  Modular.to.pop();
                },
                child: _blueBox(mediaQuery, BrazilianPortuguese().ok)),
          ],
        )
      ],
    );
  }

  // Botões de SIM e NÃO do popup
  Widget _exitAlertYesNoButton(MediaQueryData mediaQuery, int value, function) {
    return Column(
      children: [
        SizedBox(
          height: mediaQuery.size.height * 0.58,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Botão SIM
            GestureDetector(
                onTap: () {
                  if (_levelBloc.levelCoins >= value) {
                    _levelBloc.levelCoins -= value;
                  } else {
                    _userDataBloc.userData.coins -= value;
                  }
                  Modular.to.pop();
                  function();
                },
                child: _blueBox(mediaQuery, BrazilianPortuguese().yes)),
            SizedBox(
              width: mediaQuery.size.width * 0.1,
            ),
            // Botão NÃO
            GestureDetector(
                onTap: () {
                  _isTimeStop = false;
                  Modular.to.pop();
                },
                child: _blueBox(mediaQuery, BrazilianPortuguese().no)),
          ],
        )
      ],
    );
  }

  Widget _blueBox(MediaQueryData mediaQuery, String text) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: mediaQuery.size.height * 0.06,
          child: Image.asset('assets/images/blue-button-background.png'),
        ),
        Material(
          color: Colors.transparent,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
