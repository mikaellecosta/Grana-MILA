import 'dart:async';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/languages/brazilian_portuguese.dart';
import 'package:lasic_grana_flutter/app/core/storage/hive_initializer.dart';
import 'package:lasic_grana_flutter/app/core/utils/typography.dart';
import 'package:lasic_grana_flutter/app/root_module.dart';
import 'package:lasic_grana_flutter/app/root_widget.dart';
import 'package:lasic_grana_flutter/services/remote_config_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InternetVerifyHome extends StatelessWidget {
  const InternetVerifyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Verificando ',
      theme: ThemeData(
        fontFamily: AppTypography.fontFamily,
        primarySwatch: Colors.red,
      ),
      home: const InternetVerifyPage(),
    );
  }
}

class InternetVerifyPage extends StatefulWidget {
  const InternetVerifyPage({Key? key}) : super(key: key);

  @override
  InternetVerifyPageState createState() => InternetVerifyPageState();
}

class InternetVerifyPageState extends State<InternetVerifyPage> {
  String _connection = BrazilianPortuguese().disconnected;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateStatus);
    Future.delayed(const Duration(milliseconds: 100)).then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => showAlert(context));
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logo-background.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Container(
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  void _updateStatus(ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.none) {
    } else {
      updateText(BrazilianPortuguese().connected);
      await RemoteConfigService().update();
      SharedPreferences.getInstance().then((value) {
        value.setBool('isDatabaseDownloaded', true);
      });
      hiveInitializer(
          execute: () => runApp(
              ModularApp(module: RootModule(), child: const RootWidget())));
    }
  }

  void updateText(String texto) {
    setState(
      () {
        _connection = texto;
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void showAlert(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width * 0.03),
                child: Image.asset('assets/images/white-box-background.png'),
              ),
            ],
          ),

          // Titulo do status da conexão e icone wifi
          connectionStatusTittle(mediaQuery),

          // Texto no meio do Dialog - status da conexão atual
          connectionStatusChange(mediaQuery),

          // Texto no fim do Dialog - aviso para se conectar a internet
          // no 1° acesso
          disconnectedStatusInformation(mediaQuery)
        ],
      ),
    );
  }

  Widget connectionStatusTittle(MediaQueryData mediaQuery) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Column(children: [
        SizedBox(
          height: mediaQuery.size.height * 0.39,
        ),
        const Icon(
          Icons.wifi_find_sharp,
          size: 52,
          color: Color.fromRGBO(95, 2, 2, 0.836),
        ),
        SizedBox(
          height: mediaQuery.size.height * 0.02,
        ),
        Material(
            color: Colors.transparent,
            child: Text(
              BrazilianPortuguese().connectionStatus,
              textAlign: TextAlign.center,
              style: AppTypography.font24Bold()
            ))
      ])
    ]);
  }

  Widget connectionStatusChange(MediaQueryData mediaQuery) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.32),
      child: Column(
        children: [
          SizedBox(
            height: mediaQuery.size.height * 0.52,
          ),
          Material(
            color: Colors.transparent,
            child: Column(
              children: [
                Text(
                  _connection,
                  textAlign: TextAlign.center,
                  style: AppTypography.font20Bold()
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget disconnectedStatusInformation(MediaQueryData mediaQuery) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.1),
      child: Column(
        children: [
          SizedBox(
            height: mediaQuery.size.height * 0.58,
          ),
          Material(
            color: Colors.transparent,
            child: Column(
              children: [
                Text(
                  BrazilianPortuguese().internetTestMessage,
                  textAlign: TextAlign.center,
                  style: AppTypography.font20Bold()
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
