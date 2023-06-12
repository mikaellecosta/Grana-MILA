import 'dart:convert';

import 'package:hive/hive.dart';

class UserData {
  // Builder do objeto
  UserData(
      {required this.coins,
      required this.completedLevels,
      required this.productsPurchased,
      required this.skin,
      required this.levelsPlayed,
      required this.actualLevel});

  // cria um objeto do tipo UserData a partir de uma Map
  factory UserData.fromMap(Map<String, dynamic> map) => UserData(
        coins: map['coins'],
        completedLevels: map['completeLevels'],
        productsPurchased: map['productsPurchased'],
        skin: map['skin'],
        levelsPlayed: map['levelsPlayed'],
        actualLevel: map['actualLevel'],
      );
  // variaveis do usuario
  // Valor de moedas do usuario
  int coins;
  // Numero de leveis concluidos pelo usuario
  int completedLevels;
  // Lista com produtos ja comprados pelo usuario
  List<dynamic> productsPurchased;
  // Path ate a imagem da skin do usuario, no caso menino ou menina
  String skin;
  // Map que armazena dados das tentativas de concluir um level do usuario
  // TODO(YuriOliv): ajustar esse campo depois, pois eu não sei como seria feito
  // ja que não sei os dados que seriam necessarios ao google analitycs
  Map<String, dynamic> levelsPlayed;

  int actualLevel;

  // cria um Map dos dados desse objeto
  Map<String, dynamic> toMap() => {
        'coins': coins,
        'completeLevels': completedLevels,
        'productsPurchased': productsPurchased,
        'skin': skin,
        'levelsPlayed': levelsPlayed,
        'actualLevel': actualLevel,
      };

  // Funções para interagir com o Save do usuario,
  Future<void> writeUserDataInLocalStorage() async {
    // Cria ou abre algo como uma tabela com o nome entre parenteses
    final box = await Hive.openBox('USER_DATA');
    // Map das variaveis de userData
    final Map<String, dynamic> map = toMap();
    // transforma o Map anterior em um json que sera armazenado no Hive
    await box.put('save', json.encode(map));
  }

  static Future<UserData> readUserDataInLocalStorage() async {
    // Cria ou abre algo como uma tabela com o nome entre parenteses
    final box = await Hive.openBox('USER_DATA');
    final String raw = await box.get('save');
    final Map<String, dynamic> decodedUserData =
        raw == '' ? [] : json.decode(raw);
    return UserData.fromMap(decodedUserData);
  }

  Future<void> updateUserDataInLocalStorage() async {
    // Cria ou abre algo como uma tabela com o nome entre parenteses
    final box = await Hive.openBox('USER_DATA');

    // É feita a substituição do Map com variaveis no Hive
    await box.put('save', json.encode(toMap()));
  }

  static Future<void> deleteUserDataInLocalStorage() async {
    // Cria ou abre algo como uma tabela com o nome entre parenteses
    final box = await Hive.openBox('USER_DATA');
    // Deleta um campo dentro do hive
    await box.delete('save');
  }

  // Para verificar se os dados do usuario ja foram criados ou armazenados
  static Future<bool> userDataExistsInLocalStorage() async {
    final box = await Hive.openBox('USER_DATA');
    return box.containsKey('save');
  }
}
