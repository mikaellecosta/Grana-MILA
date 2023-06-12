import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/modules/levels/levels_module.dart';
import 'package:lasic_grana_flutter/app/modules/levels_menu/pages/levels_menu_page.dart';
import 'package:lasic_grana_flutter/app/modules/shop/shop_module.dart';

class LevelsMenuModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const LevelsMenuPage()),
        ModuleRoute('/Level', module: LevelsModule()),
        ModuleRoute('/Shop', module: ShopModule()),
      ];
}
