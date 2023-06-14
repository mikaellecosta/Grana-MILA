import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:lasic_grana_flutter/app/modules/levels/models/level.dart';
import 'package:lasic_grana_flutter/app/modules/levels/models/question.dart';
import 'package:lasic_grana_flutter/app/modules/shop/models/product.dart';

// Le o arquivo do remote config como uma string
class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> update() async {
    await _remoteConfig.fetchAndActivate();
  }

  Future<void> inicializar() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(days: 365),
      ),
    );
    await _remoteConfig.ensureInitialized();
  }

  // Função que pega o arquivo "quiz_questions"
  // da instancia local do remote config
  dynamic get quiz {
    // salva a string em uma variavel chamada "quiz"
    final quiz = _remoteConfig.getString('quiz_questions');

    // extrai o json da string
    final data = jsonDecode(quiz);

    // Variavel "data" agora tem varias "camadas"
    // que aparentam ser listas de maps
    // String questao = data[0]["questions"][0].toString();

    return data;
  }

  // Função que pega o arquivo "produtos" da instancia local do remote config
  dynamic get products {
    final products = _remoteConfig.getString('produtos');

    final data = jsonDecode(products);

    return data;
  }

  // Função que pega o arquivo "config" da instancia local do remote config
  dynamic get config {
    // salva a string em uma variavel chamada "configuration"
    final configuration = _remoteConfig.getString('config');

    // extrai o json da string
    final data = jsonDecode(configuration);

    // Variavel "data" agora tem varias "camadas"
    // String configuração = data[0]["level"]

    return data;
  }

  // Função que retorna um objeto level
  Level getLevel(int numberLevel) {
    final quizList = quiz[numberLevel - 1]['questions'];
    final configList = config[numberLevel - 1];
    final questions = questionForLevel(numberLevel, quizList);
    return Level(
      number: numberLevel,
      totalQuestions: quizList.length,
      questionsToComplete: configList['total_questions'],
      rewardPerQuestion: 200,
      questions: questions,
    );
  }

  // Função que retorna uma lista de objetos "question"
  // para completar o objeto "level"
  List<Question> questionForLevel(int numberLevel, List<dynamic> quizlist) {
    final listQuestions = <Question>[];
    for (final question in quizlist) {
      final answers = answersForLevel(numberLevel, question['answers']);
      listQuestions.add(Question(
        question: question['question'],
        answerIndex: question['rightAnswer'],
        answers: answers,
        tip: question['tip'],
      ));
    }
    return listQuestions;
  }

  // Função que retorna uma lista de strings que
  // serão as opções de resposta de uma pergunta de um objeto "question"
  List<String> answersForLevel(int numberLevel, List<dynamic> answersList) {
    final listAnswers = <String>[];
    for (final answer in answersList) {
      listAnswers.add(answer.toString());
    }
    return listAnswers;
  }

  //Funcao pra retornar os produtos no firebase via RemoteConfig
  List<Product> getProductList() {
    return products
        .map<Product>((product) => Product(
              name: product['nome'],
              imageUrl: product['imageUrl'],
              value: product['valor'],
            ))
        .toList();
  }
}
