import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/modules/shop/blocs/shop_bloc.dart';
import 'package:lasic_grana_flutter/app/modules/shop/pages/shop_page.dart';

class ShopModule extends Module {
  @override
  List<Bind> get binds => [
        Bind<ShopBloc>(
          (i) => ShopBloc(),
          onDispose: (bloc) => bloc.close(),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const ShopPage()),
      ];
}
