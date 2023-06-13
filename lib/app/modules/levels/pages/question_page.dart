import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_bloc.dart';
import 'package:lasic_grana_flutter/app/core/languages/brazilian_portuguese.dart';
import 'package:lasic_grana_flutter/app/core/utils/typography.dart';
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

  @override
  void initState() {
    super.initState();
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
          Column(
            children: <Widget>[
              SizedBox(height: mediaQuery.size.height * 0.83),
              // Botão que manda o usuario da tela de pergunta para tela
              // com opções de resposta
              GestureDetector(
                onTap: () => Modular.to.navigate('./AnswerOptions'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: mediaQuery.size.height * 0.11,
                      width: mediaQuery.size.width * 0.55,
                      child: Image.asset(
                        'assets/images/answer-button.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                              style: AppTypography.font20Bold(),
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
                          // 4° dado, timer vazio na pergunta
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
}
