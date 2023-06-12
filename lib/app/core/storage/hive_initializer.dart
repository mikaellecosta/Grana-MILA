import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;

Future<void> hiveInitializer({required void Function() execute}) async {
  // Retorna o path do aplicativo no dispositivo
  final applicationDocumentsDirectory =
      await path.getApplicationDocumentsDirectory();
  // Inicializa o Hive no path retornado anteriormente
  Hive.init(applicationDocumentsDirectory.path);
  //Executa o resto do app
  execute();
}
