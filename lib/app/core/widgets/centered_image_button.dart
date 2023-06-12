import 'package:flutter/material.dart';

class CenteredImageButton extends StatelessWidget {
  const CenteredImageButton({
    Key? key,
    required this.mediaQuery,
    required this.verticalSize,
    required this.horizontalSize,
    required this.localImagem,
    required this.onTap,
  }) : super(key: key);

  final MediaQueryData mediaQuery;
  final double verticalSize;
  final double horizontalSize;
  final String localImagem;
  final Function() onTap;

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
            child: Image(
              image: AssetImage(localImagem),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}
