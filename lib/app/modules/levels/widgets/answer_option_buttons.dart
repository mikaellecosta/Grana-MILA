import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';
import 'package:lasic_grana_flutter/app/core/widgets/centered_image_button_with_text.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_bloc.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_events.dart';
import 'package:lasic_grana_flutter/app/modules/levels/blocs/level_states.dart';

class AnswerOptionButton extends StatefulWidget {
  const AnswerOptionButton({
    Key? key,
    required this.mediaQuery,
    required this.verticalSize,
    required this.horizontalSize,
    required this.correctAnswerOptionNumber,
    required this.actualAnswerOptionNumber,
  }) : super(key: key);

  final MediaQueryData mediaQuery;
  final double verticalSize;
  final double horizontalSize;
  final int correctAnswerOptionNumber;
  final int actualAnswerOptionNumber;

  @override
  State<AnswerOptionButton> createState() => _AnswerOptionButtonState();
}

class _AnswerOptionButtonState extends State<AnswerOptionButton> {
  final levelBloc = Modular.get<LevelBloc>();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !levelBloc.eliminatedAnswers.contains(
        levelBloc.orderAnswers.indexOf(widget.actualAnswerOptionNumber)),
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: BlocBuilder<LevelBloc, AppState>(
          bloc: levelBloc,
          builder: (context, state) {
            if (state is UpdatingIsAnswerOptionSelected ||
                state is InitialState) {
              return const SizedBox();
            }
    
            // Cria um botão alinhado no meio da tela
            //
            // Retorna todos os fundos de botões em branco caso
            // o usuario não tenha clicado em nenhuma das respostas
            if (!levelBloc.isAnswerOptionSelected) {
              return CenteredImageButtonWithText(
                mediaQuery: widget.mediaQuery,
                verticalSize: widget.verticalSize,
                horizontalSize: widget.horizontalSize,
                localImagem: 'assets/images/white-answer-item-button.png',
                onTap: () {
                  levelBloc.add(
                    UpdateIsAnswerOptionSelectedInLevelBloc(
                        numberQuestion: widget.actualAnswerOptionNumber),
                  );
                },
                text: levelBloc.level.questions[levelBloc.actualQuestion]
                    .answers[widget.actualAnswerOptionNumber],
              );
              // Retorna diferentes fundos caso o usuario
              // tenha clicado em um botao de resposta
            } else if (levelBloc.isAnswerOptionSelected) {
              // Retorna um fundo vermelho na opção de resposta selecionada
              // caso o item que o usuario selecionou foi uma resposta errada
              if (widget.correctAnswerOptionNumber !=
                      widget.actualAnswerOptionNumber &&
                  widget.actualAnswerOptionNumber == levelBloc.optionSelected) {
                return CenteredImageButtonWithText(
                  mediaQuery: widget.mediaQuery,
                  verticalSize: widget.verticalSize,
                  horizontalSize: widget.horizontalSize,
                  localImagem: 'assets/images/red-answer-item-button.png',
                  onTap: () {},
                  text: levelBloc.level.questions[levelBloc.actualQuestion]
                      .answers[widget.actualAnswerOptionNumber],
                );
              } else if (widget.correctAnswerOptionNumber ==
                  widget.actualAnswerOptionNumber) {
                // Retorna um fundo verde na opção de resposta correta
                // sempre que o usuario clicar em alguma opção de resposta
                return CenteredImageButtonWithText(
                  mediaQuery: widget.mediaQuery,
                  verticalSize: widget.verticalSize,
                  horizontalSize: widget.horizontalSize,
                  localImagem: 'assets/images/green-answer-item-button.png',
                  onTap: () {},
                  text: levelBloc.level.questions[levelBloc.actualQuestion]
                      .answers[widget.actualAnswerOptionNumber],
                );
              } else {
                // Retorna um fundo branco caso o item não seja selecionado
                // e não seja a resposta correta
                return CenteredImageButtonWithText(
                  mediaQuery: widget.mediaQuery,
                  verticalSize: widget.verticalSize,
                  horizontalSize: widget.horizontalSize,
                  localImagem: 'assets/images/white-answer-item-button.png',
                  onTap: () {},
                  text: levelBloc.level.questions[levelBloc.actualQuestion]
                      .answers[widget.actualAnswerOptionNumber],
                );
              }
            } // Se a mensagem abaixo aparecer é um erro do programa
            return const SizedBox(
              child: Text('Error'),
            );
          }),
    );
  }
}
