abstract class TutorialEvent {}

// Evento para carregar texto em  TutorialBloc
class CreateTutorialList implements TutorialEvent {
  const CreateTutorialList();
}

// Evento para passar para proximo texto
class NextTutorial implements TutorialEvent {
  NextTutorial();
}

// Evento para passar para a proxima imagem do porco
class NextPigImage implements TutorialEvent {
  NextPigImage();
}
