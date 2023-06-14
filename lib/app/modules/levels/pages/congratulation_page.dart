import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/languages/brazilian_portuguese.dart';
import 'package:lasic_grana_flutter/app/core/utils/typography.dart';
import 'package:lasic_grana_flutter/app/core/widgets/centered_image_button_with_text.dart';
import 'package:lasic_grana_flutter/app/core/widgets/pages_background.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_bloc.dart';

class CongratulationPage extends StatelessWidget {
  CongratulationPage({super.key});

  final levelBloc = Modular.get<LevelBloc>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // Retorna
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
              SizedBox(height: mediaQuery.size.height * 0.35),

              // Texto que fica dentro da nuvem
              SizedBox(
                height: mediaQuery.size.height * 0.07,
                width: mediaQuery.size.width * 0.7,
                child: Text(
                  BrazilianPortuguese().congratulations,
                  style: AppTypography.font40Bold(),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(
                height: mediaQuery.size.height * 0.15,
                width: mediaQuery.size.width * 0.58,
                child: Center(
                  child: Text(
                    BrazilianPortuguese().levelTwo,
                    style: AppTypography.font22Bold(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              CenteredImageButtonWithText(
                  mediaQuery: mediaQuery,
                  verticalSize: 0.059,
                  horizontalSize: 0.22,
                  localImagem: 'assets/images/yellow-button-background.png',
                  text: 'OK',
                  
                  onTap: () {
                    Modular.to.navigate('./Reward');
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
