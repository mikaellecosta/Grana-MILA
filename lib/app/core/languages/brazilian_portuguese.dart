// ignore_for_file: lines_longer_than_80_chars
class BrazilianPortuguese {
  actualLevel(int actualLevel) {
    return 'Nível $actualLevel';
  }

  //initial_menu_page
  String deleteProgress = 'Você deseja apagar todo seu progresso no jogo?';

  //about_team_text
  String aboutGranaExplanation =
      ' O Grana é um projeto desenvolvido em 2018 pelo IFCE -'
      'Campus Canindé, que visa ensinar Educação Financeira para '
      'crianças dos assentamentos rurais de Canindé.';

  String reviewtests = 'Equipe LASIC';

  List<String> titles = [
    'Equipe:',
    'Programadores(Bolsistas):',
    'Designs(Voluntários):',
    'Roteiristas(Voluntárias):',
    'Coordenador(Professor):',
    'Revisão e testes:'
  ];

  List<String> scholarProgrammers = [
    'Maria Luciana Almeida Pereira',
    'Francisco Erialdo Domingos Freitas'
  ];

  List<String> volunteerDesigns = [
    'Antonia Andreza Ribeiro da Silva',
    'Rafael Lopes Costa'
  ];

  List<String> volunteerScreenwriters = [
    'Claudiane Gomes Ferreira',
    'Juliana Silva Maciel',
    'Fernanda Felipe Leal (Professora)'
  ];

  String teachercoordinator = 'Carlos Henrique Leitão Cavalcante ';

  //tutorial_page
  List tutorialList = [
    'Seja bem-vindo ao Grana!!',
    'Aqui você aprenderá a utilizar seu dinheiro da melhor forma possível!',
    'Em cada nível você responderá perguntas relacionadas ao uso adequado do dinheiro, poupando sempre que tiver oportunidade.',
    'Para passar de nível é necessário responder uma certa quantidade de perguntas corretamente.',
    'Você poderá comprar ajudas, estas irão lhe ajudar à responder as perguntas. Mas tome cuidado para não acabar o seu dinheiro comprando apenas isso.',
    'Após finalizar cada nível você poderá guardar suas moedas no Banco ou comprar alguma coisa na loja com elas.',
    'Para começar, escolha o seu personagem.',
  ];

  //answer_options_page
  String timeOver = '!!Tempo esgotado!!';
  String right = 'Acertou';
  String wrong = 'Errou';

  //congratulation_page
  String congratulations = 'Parabéns!!';
  String levelTwo = 'Você está no nível 2!!';

  //level_closing_with_earned_coins_page
  String attention = 'Atenção!';
  String storeCoins = 'Suas moedas serão armazenadas em sua Conta no Banco.';

  //notify_max_reward_page
  notifyMaxRewarValue(int questionsToComplete) {
    return 'Valendo ${200 * questionsToComplete} moedas!! ';
  }

  //reward_page
  String unfortunately = 'Infelizmente!';
  String tryAgain = 'Você não conseguiu nenhuma moeda. Tente novamente!';
  String spare = 'Poupar';

  rewardValue(int correctQuestions) {
    return ' Você ganhou ${correctQuestions * 200} moedas! \n '
        'O que você deseja fazer com suas moedas? ';
  }

  //treasure_button
  String lockedLevel = 'Infelizmente, este nível está bloqueado';

  //internet_verify_page
  String disconnected = 'Desconectado';
  String connected = 'Conectado';
  String connectionStatus = 'Status da conexão';
  String internetTestMessage = 'No primeiro acesso é necessário'
      ' estar conectado à internet.';

  //shop_page
  String itemAlreadyAdquired = 'Você já adquiriu esse item!';
  String confirmationBuyItem = 'Você deseja realmente comprar este item?';
  String insuficientCoins = 'Infelizmente, você não possui moedas suficientes!';
}
