import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_bloc.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_events.dart';
import 'package:lasic_grana_flutter/app/core/languages/brazilian_portuguese.dart';
import 'package:lasic_grana_flutter/app/core/widgets/pages_background.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_bloc.dart';

class LevelClosingWithEarnedCoinsPage extends StatelessWidget {
  LevelClosingWithEarnedCoinsPage({super.key});

  final levelBloc = Modular.get<LevelBloc>();
  final userDataBloc = Modular.get<UserDataBloc>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // Soma as moedas do usuario com as moedas ganhas no level
    userDataBloc.userData.coins =
        userDataBloc.userData.coins + levelBloc.levelCoins;

    // Armazena os dados localmente com Hive
    userDataBloc.add(const UpdateUserData());

    // Dialogo de alerta para sair da pagina
    // Como a função showDialog não pode ser chamada diretamente no Stack,
    // por sem um Future, temos que chama-la aqui

    // Observação: ao fazer um hot reload muitas vezes o fundo fica preto,
    // pois são chamados varios showDialogs,
    // alem disso é feito a soma do valor ganho na fase todos hot reload
    Future.delayed(
      Duration.zero,
      () => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Stack(
          children: [
            // Imagem de fundo do Dialog
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width * 0.03),
                child: Image.asset('assets/images/white-box-background.png'),
              ),
            ),
            // Texto no inicio do Dialog
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: mediaQuery.size.height * 0.37,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      BrazilianPortuguese().attention,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ),
            // Texto no meio do Dialog
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width * 0.2),
                child: Column(
                  children: [
                    SizedBox(
                      height: mediaQuery.size.height * 0.45,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: Text(
                        BrazilianPortuguese().storeCoins,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Botão no fim do Dialog
            yellowButtonToNextPage(mediaQuery),
          ],
        ),
      ),
    );

    // Retorna a tela em si
    return Scaffold(
      body: Stack(
        children: [
          // Column da imagem mostrando o menu dentro da fase
          PagesBackground(
              mediaQuery: mediaQuery,
              localImagem: 'assets/images/green-mountains-background.png'),
        ],
      ),
    );
  }

  Widget yellowButtonToNextPage(MediaQueryData mediaQuery) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: mediaQuery.size.height * 0.58,
          ),
          GestureDetector(
            onTap: () => Modular.to.navigate('../'),
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: mediaQuery.size.height * 0.06,
                    child: Image.asset(
                        'assets/images/yellow-button-background.png'),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: mediaQuery.size.height * 0.015,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: const Material(
                        color: Colors.transparent,
                        child: Text(
                          'OK',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
