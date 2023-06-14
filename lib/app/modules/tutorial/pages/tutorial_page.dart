import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_bloc.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_events.dart';
import 'package:lasic_grana_flutter/app/core/widgets/pages_background.dart';
import 'package:lasic_grana_flutter/app/modules/tutorial/blocs/tutorial_bloc.dart';
import 'package:lasic_grana_flutter/app/modules/tutorial/blocs/tutorial_event.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final _userDataBloc = Modular.get<UserDataBloc>();
  final _tutorialBloc = Modular.get<TutorialBloc>();

  @override
  void initState() {
    super.initState();
    _startTimer(); // esperar animação acabar
    _tutorialBloc.add(const CreateTutorialList());
  }

  // Animação porco
  _startTimer() {
    Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (_tutorialBloc.actualPigImage < _tutorialBloc.pigList.length - 1) {
        _tutorialBloc.add(NextPigImage());
      }
    });
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

          BlocBuilder<TutorialBloc, AppState>(
              bloc: _tutorialBloc,
              builder: (context, state) {
                if (state is InitialState) {
                  return const SizedBox();
                }
                // animação do porco
                if (_tutorialBloc.actualPigImage !=
                    _tutorialBloc.pigList.length - 1) {
                  // Esse widget cria a imagem/animação do porco saindo do baú
                  return _buildPigImage(mediaQuery);
                }
                // Tutorial (textos)
                if (_tutorialBloc.actualTutorial !=
                    _tutorialBloc.tutorialList.length) {
                  return Stack(
                    children: <Widget>[
                      // Esse widget cria a imagem/animação do porco saindo do baú
                      _buildPigImage(mediaQuery),
                      // resto da tela
                      Column(
                        children: [
                          SizedBox(
                            height: mediaQuery.size.height * 0.23,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Botão de próximo
                              _imageButtonWithText(mediaQuery, 'PRÓXIMO',
                                  () => _tutorialBloc.add(NextTutorial())),
                              // Botão de pular
                              _imageButtonWithText(mediaQuery, 'PULAR', () {
                                _tutorialBloc.actualTutorial =
                                    _tutorialBloc.tutorialList.length - 1;
                                _tutorialBloc.add(NextTutorial());
                              }),
                            ],
                          ),
                          // Balão de fala
                          _speechBubble(
                              mediaQuery, _buildTextComponent(mediaQuery)),
                        ],
                      ),
                    ],
                  );
                }
                // Escolha do avatar
                return Stack(children: <Widget>[
                  // Esse widget cria a imagem/animação do porco saindo do baú
                  _buildPigImage(mediaQuery),
                  // Resto da tela
                  Column(
                    children: [
                      SizedBox(
                        height: mediaQuery.size.height * 0.05,
                      ),
                      // Campo "Você é?"
                      _youAreBox(mediaQuery),
                      // Espaço
                      SizedBox(
                        height: mediaQuery.size.height * 0.03,
                      ),
                      // Balão de fala
                      _speechBubble(
                          mediaQuery,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _userSkin(mediaQuery,
                                  'assets/images/girl-avatar.png', 'MENINA'),
                              _userSkin(mediaQuery,
                                  'assets/images/boy-avatar.png', 'MENINO'),
                            ],
                          )),
                    ],
                  ),
                ]);
              }),
        ],
      ),
    );
  }

  // Animação porco
  Widget _buildPigImage(MediaQueryData mediaQuery) {
    final actualPigImage = _tutorialBloc.pigList[_tutorialBloc.actualPigImage];
    return Align(
      alignment: Alignment.bottomLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: SizedBox(
              height: mediaQuery.size.height * 0.25,
              child: Image.asset(
                actualPigImage,
                key: ValueKey<String>(actualPigImage),
              ),
            ),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ],
      ),
    );
  }

  // Botões com imagem e texto para PROXIMO e PULAR
  Widget _imageButtonWithText(
      MediaQueryData mediaQuery, String text, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          alignment: Alignment.center,
          width: mediaQuery.size.width * 0.35,
          height: mediaQuery.size.height * 0.17,
          padding: EdgeInsets.only(top: mediaQuery.size.height * 0.06),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/icon-play.png'))),
          child: Text(
            text,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          )),
    );
  }

  // Balão de fala
  Widget _speechBubble(MediaQueryData mediaQuery, Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          height: mediaQuery.size.height * 0.35,
          width: mediaQuery.size.width * 0.95,
          padding: EdgeInsets.only(
              bottom: mediaQuery.size.height * 0.05,
              left: mediaQuery.size.width * 0.05,
              right: mediaQuery.size.width * 0.05),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/white-speech-bubble.png'),
                  fit: BoxFit.fill)),
          child: child, // conteudo do balão de fala
        ),
      ],
    );
  }

  // Widget texto/mensagens do tutorial
  Widget _buildTextComponent(MediaQueryData mediaQuery) {
    return Text(
      _tutorialBloc.tutorialList[_tutorialBloc.actualTutorial],
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  //Campo "Você é?""
  Widget _youAreBox(MediaQueryData mediaQuery) {
    return Visibility(
      visible:
          (_tutorialBloc.actualTutorial == _tutorialBloc.tutorialList.length),
      child: SizedBox(
        width: mediaQuery.size.width * 0.55,
        height: mediaQuery.size.height * 0.3,
        child: Image.asset(
          'assets/images/you-are-box.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  // Widget skin (menino/menina)
  Widget _userSkin(MediaQueryData mediaQuery, String image, String name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            _userDataBloc.add(CreateNewUserData(skin: image));
            _userDataBloc.add(const UpdateUserData());
            Modular.to.navigate('/LevelsMenu/');
          },
          child: SizedBox(
            height: mediaQuery.size.height * 0.23,
            width: mediaQuery.size.width * 0.42,
            child: Image.asset(image, fit: BoxFit.fill),
          ),
        ),
        Text(name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
