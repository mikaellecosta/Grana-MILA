import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Função que retorna a Url da imagem do banco de dados
  Future<String> downloadURL(String imageName) async {
    final downloadURL = await storage.ref(imageName).getDownloadURL();

    return downloadURL;
  }
}
