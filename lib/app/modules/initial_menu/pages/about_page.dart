import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/widgets/pages_background.dart';
import 'package:lasic_grana_flutter/app/modules/initial_menu/widgets/about_team_text.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
              localImagem: 'assets/images/about-background.png'),
          // Column serve para poder usar um SizedBox para dar o ajuste vertical
          Column(
            children: [
              SizedBox(
                height: mediaQuery.size.height * 0.07,
              ),
              // Botão "sobre"
              Row(
                children: [
                  SizedBox(
                    width: mediaQuery.size.width * 0.06,
                  ),
                  SizedBox(
                    height: mediaQuery.size.height * 0.11,
                    width: mediaQuery.size.width * 0.58,
                    child: Image.asset(
                      'assets/images/button-about.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: mediaQuery.size.height * 0.02,
              ),
              // Botão para fechar view "sobre"
              GestureDetector(
                onTap: () => Modular.to.navigate('/'),
                child: Row(
                  children: [
                    SizedBox(
                      width: mediaQuery.size.width * 0.80,
                    ),
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
          // Texto falando sobre o projeto Grana e equipe
          AboutTeamText(mediaQuery: mediaQuery),
        ],
      ),
    );
  }
}
