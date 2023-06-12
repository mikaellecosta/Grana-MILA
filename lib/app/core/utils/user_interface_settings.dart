import 'package:flutter/services.dart';

class UserInterfaceSettings {
  void definingScreenSettings() {
    // Esconde a barra inferior do android
    // Arrastando para cima na area da barra faz ela reaparecer
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    /*Força a tela a estar na vertical. Pode não funcionar em alguns 
    dispositivos IOS.*/

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}
