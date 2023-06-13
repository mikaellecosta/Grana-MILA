import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_bloc.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_events.dart';
import 'package:lasic_grana_flutter/app/core/widgets/centered_image_button.dart';
import 'package:lasic_grana_flutter/app/core/widgets/pages_background.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final userDataBloc = Modular.get<UserDataBloc>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // TODO(YuriOliv): criar tela depois
    // Retorna a tela em si, com uma imagem de fundo cobrindo toda a tela
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Esse widget cria a imagem de fundo da tela
          PagesBackground(
              mediaQuery: mediaQuery,
              localImagem: 'assets/images/green-mountains-background.png'),
          // TODO(YuriOliv): teste temporario para criar dados do usuario,
          // criar resto da tela depois
          Center(
            child: CenteredImageButton(
              mediaQuery: mediaQuery,
              verticalSize: 0.05,
              horizontalSize: 0.2,
              localImagem: 'assets/images/blue-button-background.png',
              onTap: () {
                userDataBloc.add(const CreateNewUserData());
                Modular.to.navigate('/LevelsMenu/');
              },
            ),
          ),
        ],
      ),
    );
  }
}
