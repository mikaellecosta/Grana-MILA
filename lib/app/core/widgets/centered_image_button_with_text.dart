import 'package:flutter/material.dart';

class CenteredImageButtonWithText extends StatelessWidget {

  const CenteredImageButtonWithText({
    Key? key,
    required this.mediaQuery,
    required this.verticalSize,
    required this.horizontalSize,
    required this.localImagem,
    required this.text,
    this.buttonTextFontSize = 16,
    required this.onTap,
  }) : super(key: key);
  final MediaQueryData mediaQuery;
  final double verticalSize;
  final double horizontalSize;
  final String localImagem;
  final String text;
  final Function() onTap;
  final double buttonTextFontSize;

  @override
  Widget build(BuildContext context) {
    // Cria um botão alinhado no meio da tela
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: onTap,
          child: SizedBox(
            height: mediaQuery.size.height * verticalSize,
            width: mediaQuery.size.width * horizontalSize,
            child: Stack(
              children: [
                Image(
                  image: AssetImage(localImagem),
                  fit: BoxFit.fill,
                ),
                Center(
                  child: SizedBox(
                    height: mediaQuery.size.height * 0.07,
                    width: mediaQuery.size.width * 0.75,
                    child: Center(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: buttonTextFontSize,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
