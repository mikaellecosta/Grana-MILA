import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_bloc.dart';
import 'package:lasic_grana_flutter/app/core/widgets/pages_background.dart';
import 'package:lasic_grana_flutter/app/modules/levels_menu/widgets/treasure_button.dart';

class LevelsMenuPage extends StatefulWidget {
  const LevelsMenuPage({super.key});

  @override
  State<LevelsMenuPage> createState() => _LevelsMenuPageState();
}

class _LevelsMenuPageState extends State<LevelsMenuPage> {
  final _userDataBloc = Modular.get<UserDataBloc>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final String userSkin = _userDataBloc.userData.skin;
    // Ao mudar essa variavel, os baus vão mudando de
    // imagem e sendo desbloqueados
    final int levelsCompleted = _userDataBloc.userData.completedLevels;

    // Retorna a tela em si, com uma imagem de fundo cobrindo toda a tela
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Esse widget cria a imagem de fundo da tela
          PagesBackground(
              mediaQuery: mediaQuery,
              localImagem: 'assets/images/chest-path-background.png'),
          // Column do botão "voltar", volta para a view de menu inicial
          Column(
            children: <Widget>[
              SizedBox(
                height: mediaQuery.size.height * 0.06,
              ),
              // Botão "voltar", volta para a view de menu inicial
              _backButton(mediaQuery),
            ],
          ),
          // Column da imagem mostrando o valor atual no banco do jogador
          Column(
            children: <Widget>[
              SizedBox(
                height: mediaQuery.size.height * 0.05,
              ),
              // Imagem mostrando o valor atual no banco do jogador
              _coinBox(mediaQuery),
            ],
          ),

          // Column do botão da fase 5
          TreasureButton(
              mediaQuery: mediaQuery,
              verticalSize: 0.62,
              horizontalSize: 0.78,
              chestVerticalSize: 0.08,
              chestHorizontalSize: 0.14,
              levelsCompleted: levelsCompleted,
              thisLevel: 5),
          // Column do botão da fase 4
          TreasureButton(
              mediaQuery: mediaQuery,
              verticalSize: 0.606,
              horizontalSize: 0.42,
              chestVerticalSize: 0.08,
              chestHorizontalSize: 0.14,
              levelsCompleted: levelsCompleted,
              thisLevel: 4),
          // Column do botão da fase 3
          TreasureButton(
              mediaQuery: mediaQuery,
              verticalSize: 0.69,
              horizontalSize: 0.693,
              chestVerticalSize: 0.08,
              chestHorizontalSize: 0.14,
              levelsCompleted: levelsCompleted,
              thisLevel: 3),
          // Column do botão da fase 2
          TreasureButton(
              mediaQuery: mediaQuery,
              verticalSize: 0.77,
              horizontalSize: 0.52,
              chestVerticalSize: 0.09,
              chestHorizontalSize: 0.16,
              levelsCompleted: levelsCompleted,
              thisLevel: 2),

          // Column do botão da fase 1
          TreasureButton(
              mediaQuery: mediaQuery,
              verticalSize: 0.83,
              horizontalSize: 0.18,
              chestVerticalSize: 0.12,
              chestHorizontalSize: 0.20,
              levelsCompleted: levelsCompleted,
              thisLevel: 1),
          // skin do usuario
          _buildAvatar(mediaQuery, userSkin),

          // Column do botão que leva a view de loja
          Column(
            children: <Widget>[
              SizedBox(
                height: mediaQuery.size.height * 0.87,
              ),
              // Botão que leva a view de loja
              _storeButton(mediaQuery),
            ],
          ),
        ],
      ),
    );
  }

  Widget _backButton(MediaQueryData mediaQuery) {
    return GestureDetector(
      onTap: () => Modular.to.navigate('../'),
      child: Row(
        children: [
          SizedBox(
            width: mediaQuery.size.width * 0.80,
          ),
          SizedBox(
            height: mediaQuery.size.height * 0.08,
            width: mediaQuery.size.width * 0.16,
            child: Image.asset(
              'assets/images/button-return.png',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  Widget _storeButton(MediaQueryData mediaQuery) {
    return GestureDetector(
      onTap: () => Modular.to.navigate('./Shop/'),
      child: Row(
        children: [
          SizedBox(
            width: mediaQuery.size.width * 0.77,
          ),
          SizedBox(
            height: mediaQuery.size.height * 0.09,
            width: mediaQuery.size.width * 0.16,
            child: Image.asset(
              'assets/images/mini-button-store.png',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  Widget _coinBox(MediaQueryData mediaQuery) {
    return Row(
      children: [
        SizedBox(
          width: mediaQuery.size.width * 0.19,
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: mediaQuery.size.height * 0.11,
          width: mediaQuery.size.width * 0.58,
          padding: EdgeInsets.only(
              left: mediaQuery.size.width * 0.28,
              top: mediaQuery.size.height * 0.02),
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/white-coin-box-background.png'),
            fit: BoxFit.fill,
          )),
          child: Text(
            '${_userDataBloc.userData.coins}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(MediaQueryData mediaQuery, String userSkin) {
    switch (_userDataBloc.userData.actualLevel) {
      case 1:
        return _avatarContainer(0.785, 0.2, mediaQuery, userSkin);
      case 2:
        return _avatarContainer(0.718, 0.52, mediaQuery, userSkin);
      case 3:
        return _avatarContainer(0.64, 0.68, mediaQuery, userSkin);
      case 4:
        return _avatarContainer(0.57, 0.77, mediaQuery, userSkin);
      case 5:
        return _avatarContainer(0.555, 0.41, mediaQuery, userSkin);
    }
    return const Text('Error');
  }

  Widget _avatarContainer(double percentMarginHeight, double percentMarginWidth,
      MediaQueryData mediaQuery, String userSkin) {
    return Container(
        margin: EdgeInsets.only(
            top: mediaQuery.size.height * percentMarginHeight,
            left: mediaQuery.size.width * percentMarginWidth),
        height: mediaQuery.size.height * 0.075,
        width: mediaQuery.size.width * 0.15,
        child: Image.asset(
          userSkin,
          fit: BoxFit.fill,
        ));
  }
}
