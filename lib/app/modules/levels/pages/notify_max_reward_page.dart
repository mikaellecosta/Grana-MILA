import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';
import 'package:lasic_grana_flutter/app/core/languages/brazilian_portuguese.dart';
import 'package:lasic_grana_flutter/app/core/widgets/pages_background.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_bloc.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_events.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_states.dart';

class NotifyMaxRewardPage extends StatefulWidget {
  const NotifyMaxRewardPage({super.key, required this.numberLevel});

  final int numberLevel;

  @override
  State<NotifyMaxRewardPage> createState() => _NotifyMaxRewardPageState();
}

class _NotifyMaxRewardPageState extends State<NotifyMaxRewardPage> {
  final levelBloc = Modular.get<LevelBloc>();
  Timer? timer;

  @override
  void initState() {
    levelBloc.add(UpdateLevelInLevelBloc(levelNumber: widget.numberLevel));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // Timer para mudar para a tela com questões
    timer = Timer(const Duration(seconds: 3), () {
      Modular.to.navigate('./Question', arguments: widget.numberLevel);
    });

    // Tela com o valor maximo de moedas que é possivel ganhar na fase
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Column da imagem mostrando o menu dentro da fase
          PagesBackground(
              mediaQuery: mediaQuery,
              localImagem: 'assets/images/green-mountains-background.png'),
          Center(
            child: BlocBuilder<LevelBloc, AppState>(
              bloc: levelBloc,
              builder: (context, state) {
                if (state is InitialState || state is UpdatingLevel) {
                  return const SizedBox();
                }

                return Text(
                  BrazilianPortuguese()
                      .notifyMaxRewarValue(levelBloc.level.questionsToComplete),
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w900),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
