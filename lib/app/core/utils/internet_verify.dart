import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/storage/hive_initializer.dart';
import 'package:lasic_grana_flutter/app/core/widgets/internet_verify_page.dart';
import 'package:lasic_grana_flutter/app/root_module.dart';
import 'package:lasic_grana_flutter/app/root_widget.dart';
import 'package:lasic_grana_flutter/services/remote_config_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InternetVerify {
  void verifyToInitializeApp() {
    Connectivity().checkConnectivity().then((value) async {
      if (value != ConnectivityResult.none) {
        await RemoteConfigService().update();
        SharedPreferences.getInstance().then((value) {
          value.setBool('isDatabaseDownloaded', true);
        });
        hiveInitializer(
            execute: () => runApp(
                ModularApp(module: RootModule(), child: const RootWidget())));
      } else {
        runApp(const InternetVerifyHome());
      }
    });
  }
}
