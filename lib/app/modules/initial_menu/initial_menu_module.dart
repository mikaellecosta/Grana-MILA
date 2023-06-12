import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/modules/initial_menu/pages/about_page.dart';
import 'package:lasic_grana_flutter/app/modules/initial_menu/pages/initial_menu_page.dart';
import 'package:lasic_grana_flutter/app/modules/levels_menu/levels_menu_module.dart';
import 'package:lasic_grana_flutter/app/modules/shop/shop_module.dart';
import 'package:lasic_grana_flutter/app/modules/tutorial/tutorial_module.dart';

class InitialMenuModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const InitialMenuPage()),
        ChildRoute('/About', child: (_, __) => const AboutPage()),
        ModuleRoute('/Shop', module: ShopModule()),
        ModuleRoute('/Tutorial', module: TutorialModule()),
        ModuleRoute('/LevelsMenu', module: LevelsMenuModule())
      ];
}
