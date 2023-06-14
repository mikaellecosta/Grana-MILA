import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/modules/levels_menu/levels_menu_module.dart';
import 'package:lasic_grana_flutter/app/modules/tutorial/blocs/tutorial_bloc.dart';
import 'package:lasic_grana_flutter/app/modules/tutorial/pages/tutorial_page.dart';

class TutorialModule extends Module {
  @override
  List<Bind> get binds => [
        Bind<TutorialBloc>(
          (i) => TutorialBloc(),
          onDispose: (bloc) => bloc.close(),
        ),
      ];
      
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const TutorialPage()),
        ModuleRoute('/LevelsMenu', module: LevelsMenuModule())
      ];
}
