import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/storage/hive_initializer.dart';
import 'package:lasic_grana_flutter/app/core/utils/internet_verify.dart';
import 'package:lasic_grana_flutter/app/core/utils/user_interface_settings.dart';
import 'package:lasic_grana_flutter/app/root_module.dart';
import 'package:lasic_grana_flutter/app/root_widget.dart';
import 'package:lasic_grana_flutter/services/remote_config_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await RemoteConfigService().inicializar();

  UserInterfaceSettings().definingScreenSettings();

  // Variavel de testes para verificar se questões ja foram baixadas do Firebase
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('isDatabaseDownloaded')) {
    await prefs.setBool('isDatabaseDownloaded', false);
  }

  // Verificando se o dispositivo tem
  // internet e baixando questões do Firebase caso haja
  if (!prefs.getBool('isDatabaseDownloaded')!) {
    InternetVerify().verifyToInitializeApp();
  } else {
    // TODO(YuriOliv): apagar listener depois,
    //  ele esta aqui apenas para aprendizado
    Modular.to.addListener(() {
      if (kDebugMode) {
        print(Modular.to.path);
      }
    });

    hiveInitializer(
        execute: () => runApp(
            ModularApp(module: RootModule(), child: const RootWidget())));
  }
}
