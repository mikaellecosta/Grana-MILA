import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_bloc.dart';
import 'package:lasic_grana_flutter/app/modules/initial_menu/initial_menu_module.dart';

class RootModule extends Module {
  @override
  List<Bind> get binds => [
        Bind<UserDataBloc>(
          (i) => UserDataBloc(),
          // onDispose: (bloc) => bloc.close(), // Este Bloc pode ser acesso de qualquer rota
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/', module: InitialMenuModule()),
      ];
}
