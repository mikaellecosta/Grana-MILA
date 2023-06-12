import 'package:flutter/material.dart';

class PagesBackground extends StatelessWidget {
  const PagesBackground({
    Key? key,
    required this.mediaQuery,
    required this.localImagem,
  }) : super(key: key);

  final MediaQueryData mediaQuery;
  final String localImagem;

  @override
  Widget build(BuildContext context) {
    // Este Container coloca a imagem de fundo na tela
    return Container(
      height: mediaQuery.size.height,
      width: mediaQuery.size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(localImagem),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
