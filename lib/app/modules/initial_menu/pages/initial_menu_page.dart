import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_bloc.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_events.dart';
import 'package:lasic_grana_flutter/app/core/languages/brazilian_portuguese.dart';
import 'package:lasic_grana_flutter/app/core/models/user_data.dart';
import 'package:lasic_grana_flutter/app/core/widgets/centered_image_button.dart';
import 'package:lasic_grana_flutter/app/core/widgets/pages_background.dart';
import 'package:lasic_grana_flutter/app/core/utils/typography.dart';

class InitialMenuPage extends StatefulWidget {
  const InitialMenuPage({super.key});

  @override
  State<InitialMenuPage> createState() => _InitialMenuPageState();
}

class _InitialMenuPageState extends State<InitialMenuPage> {
  final _userDataBloc = Modular.get<UserDataBloc>();

  @override
  void initState() {
    _userDataBloc.add(const VerifyIfUserDataExist());
    // Caso exista um Save ele é carregado para ser utilizado pelo botão
    // "Continuar" e "Loja"
    if (_userDataBloc.isSaved) {
      // Le os dados do Save do usuario e depois manda para a tela de fases
      _userDataBloc.add(const ReadUserData());
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // Retorna a tela em si, com uma imagem de fundo cobrindo toda a tela
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Esse widget cria a imagem de fundo da tela
          PagesBackground(
              mediaQuery: mediaQuery,
              localImagem: 'assets/images/green-mountains-background.png'),
          // TODO(YuriOliv): falta a splash screen entre views
          // Da pra tornar os botões componentes e mandar os paths para eles
          Column(
            children: <Widget>[
              // Logo no topo da tela
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: mediaQuery.size.height * 0.33,
                    width: mediaQuery.size.width * 0.82,
                    child: const Image(
                      image: AssetImage('assets/images/grana-logo.png'),
                    ),
                  ),
                ],
              ),
              // Espaço entre imagens
              SizedBox(height: mediaQuery.size.height * 0.04),

              // Botão "continuar jogo"
              BlocBuilder<UserDataBloc, AppState>(
                  bloc: _userDataBloc,
                  builder: (context, state) {
                    if (state is InitialState) {
                      return const SizedBox();
                    }

                    if (_userDataBloc.isSaved) {
                      return CenteredImageButton(
                        mediaQuery: mediaQuery,
                        verticalSize: 0.14,
                        horizontalSize: 0.68,
                        localImagem: 'assets/images/button-continue.png',
                        onTap: () {
                          Modular.to.navigate('/LevelsMenu/');
                        },
                      );
                    } else if (!_userDataBloc.isSaved) {
                      return SizedBox(
                        height: mediaQuery.size.height * 0.14,
                        width: mediaQuery.size.width * 0.68,
                      );
                    }

                    return const SizedBox(
                      child: Text('Error'),
                    );
                  }),

              // Espaço entre imagens
              SizedBox(height: mediaQuery.size.height * 0.01),
              // Botão "novo jogo"
              CenteredImageButton(
                mediaQuery: mediaQuery,
                verticalSize: 0.14,
                horizontalSize: 0.68,
                localImagem: 'assets/images/new-game-button.png',
                onTap: () {
                  // Caso o usuario ja tenha um jogo salvo devera ser
                  // perguntado se ele quer apagar o jogo atual
                  if (_userDataBloc.isSaved) {
                    // showDialog tem que ter o Widget "Material" em todos os
                    // textos pois não esta reconhecendo nenhum estilo de texto
                    showDialog(
                      context: context,
                      builder: (context) => Stack(
                        children: <Widget>[
                          // Imagem de fundo do Dialog
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: mediaQuery.size.width * 0.03),
                                child: Image.asset(
                                    'assets/images/white-box-background.png'),
                              ),
                            ],
                          ),
                          // Texto no inicio do Dialog
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: mediaQuery.size.height * 0.37,
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      'Alerta',
                                      textAlign: TextAlign.center,
                                      style: AppTypography.font24Bold(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Texto no meio do Dialog
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: mediaQuery.size.width * 0.1),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: mediaQuery.size.height * 0.45,
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    BrazilianPortuguese().deleteProgress,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.font20Bold(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Botão no fim do Dialog
                          Column(
                            children: [
                              SizedBox(
                                height: mediaQuery.size.height * 0.55,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // 1° botão do alert dialog
                                  GestureDetector(
                                    onTap: () {
                                      UserData.deleteUserDataInLocalStorage();
                                      Modular.to.navigate('/Tutorial/');
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          height: mediaQuery.size.height * 0.06,
                                          child: Image.asset(
                                              'assets/images/blue-button-background.png'),
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            'Sim',
                                            style: AppTypography.font20Bold(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Espaço entre botões
                                  SizedBox(
                                    width: mediaQuery.size.width * 0.1,
                                  ),
                                  // 2° botão do alert dialog
                                  GestureDetector(
                                    onTap: () {
                                      Modular.to.pop();
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          height: mediaQuery.size.height * 0.06,
                                          child: Image.asset(
                                              'assets/images/blue-button-background.png'),
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            'Não',
                                            style: AppTypography.font20Bold(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                    // Caso não haja jogo salva
                  } else if (!_userDataBloc.isSaved) {
                    Modular.to.navigate('/Tutorial/');
                  }
                },
              ),
              // Espaço entre imagens
              SizedBox(height: mediaQuery.size.height * 0.01),
              // Botão de loja
              CenteredImageButton(
                mediaQuery: mediaQuery,
                verticalSize: 0.14,
                horizontalSize: 0.68,
                localImagem: 'assets/images/button-store.png',
                onTap: () => Modular.to.navigate('/Shop/'),
              ),
              // Espaço entre imagens
              SizedBox(height: mediaQuery.size.height * 0.01),
              // Botão "sobre"
              CenteredImageButton(
                mediaQuery: mediaQuery,
                verticalSize: 0.14,
                horizontalSize: 0.68,
                localImagem: 'assets/images/button-about.png',
                onTap: () => Modular.to.navigate('/About'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
