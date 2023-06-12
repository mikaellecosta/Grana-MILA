import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_bloc.dart';
import 'package:lasic_grana_flutter/app/modules/levels/pages/answer_options_page.dart';
import 'package:lasic_grana_flutter/app/modules/levels/pages/congratulation_page.dart';
import 'package:lasic_grana_flutter/app/modules/levels/pages/level_closing_with_earned_coins_page.dart';
import 'package:lasic_grana_flutter/app/modules/levels/pages/notify_max_reward_page.dart';
import 'package:lasic_grana_flutter/app/modules/levels/pages/question_page.dart';
import 'package:lasic_grana_flutter/app/modules/levels/pages/reward_page.dart';

class LevelsModule extends Module {
  @override
  List<Bind> get binds => [
        Bind<LevelBloc>(
          (i) => LevelBloc(),
          onDispose: (bloc) => bloc.close(),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (_, args) => NotifyMaxRewardPage(
            numberLevel: args.data,
          ),
        ),
        ChildRoute(
          '/Question',
          child: (_, args) => const QuestionPage(),
        ),
        ChildRoute('/AnswerOptions',
            child: (_, args) => const AnswerOptionsPage()),
        ChildRoute('/Reward', child: (_, args) => RewardPage()),
        ChildRoute('/LevelClosingWithEarnedCoins',
            child: (_, args) => LevelClosingWithEarnedCoinsPage()),
        ChildRoute('/Congratulations',
            child: (_, args) => CongratulationPage()),
      ];
}
