import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_bloc.dart';
import 'package:lasic_grana_flutter/app/core/utils/typography.dart';
import 'package:lasic_grana_flutter/app/core/widgets/pages_background.dart';
import 'package:lasic_grana_flutter/app/modules/shop/blocs/shop_bloc.dart';
import 'package:lasic_grana_flutter/app/modules/shop/blocs/shop_events.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final userDataBloc = Modular.get<UserDataBloc>();
  final shopBloc = Modular.get<ShopBloc>();

  @override
  void initState() {
    shopBloc.add(const CreateProductListInShopBloc());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // TODO(YuriOliv): Faltam funções para o botão de comprar
    // Retorna a tela em si
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Esse widget cria a imagem de fundo da tela
          PagesBackground(
              mediaQuery: mediaQuery,
              localImagem: 'assets/images/store-background.png'),
          // Column com imagem do banco do jogador e botão de comprar
          Column(
            children: [
              SizedBox(
                height: mediaQuery.size.height * 0.08,
              ),
              // Imagem mostrando o valor atual no banco do jogador
              imgBank(mediaQuery),
              SizedBox(
                height: mediaQuery.size.height * 0.61,
              ),
              // Botão comprar da loja,
              buyButton(mediaQuery),
            ],
          ),

          // Column com valor do banco do usuario
          BlocBuilder<UserDataBloc, AppState>(
              // TODO(YuriOliv): testar se este bloc esta trocando
              //  o valor de moedas do usuario ao clicar no botão comprar
              bloc: userDataBloc,
              builder: (context, state) {
                if (state is InitialState) {
                  return const SizedBox();
                }
                return Column(
                  children: [
                    SizedBox(
                      height: mediaQuery.size.height * 0.124,
                    ),
                    // Imagem mostrando o valor atual no banco do jogador
                    Row(
                      children: [
                        SizedBox(width: mediaQuery.size.width * 0.48),
                        SizedBox(
                          width: mediaQuery.size.width * 0.25,
                          height: mediaQuery.size.height * 0.04,
                          child: Text(
                            userDataBloc.isSaved
                                ? '${userDataBloc.userData.coins}'
                                : '0',
                            style: AppTypography.font28Bold(),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
          // Column para botão de fechar view loja
          Column(
            children: [
              SizedBox(
                height: mediaQuery.size.height * 0.07,
              ),
              // Botão para fechar view "loja"
              exitButton(mediaQuery)
            ],
          ),
          // Column para colocar os produtos da loja
          BlocBuilder<ShopBloc, AppState>(
              bloc: shopBloc,
              builder: (context, state) {
                if (state is InitialState) {
                  return const SizedBox();
                }

                return Column(
                  children: [
                    SizedBox(
                      height: mediaQuery.size.height * 0.45,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Espaço para centralizar imagem
                        Column(
                          children: [
                            // Mostra nome do produto
                            Text(
                              shopBloc.productList[shopBloc.actualProduct].name,
                              style: AppTypography.font28BoldColor(),
                            ),
                            // Mostra imagem do produto
                            SizedBox(
                              height: mediaQuery.size.height * 0.13,
                              width: mediaQuery.size.width * 0.28,
                              child: Image(
                                image: AssetImage(
                                  shopBloc.productList[shopBloc.actualProduct]
                                      .imageUrl,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            //
                            SizedBox(
                              height: mediaQuery.size.height * 0.008,
                            ),
                            // Mostra valor do produto
                            Text(
                              shopBloc.productList[shopBloc.actualProduct].value
                                  .toString(),
                              style: AppTypography.font24BoldColorWhite(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }),
          // Coluna com os botões de item anterior e proximo item
          BlocBuilder<ShopBloc, AppState>(
            bloc: shopBloc,
            builder: (context, state) {
              if (state is InitialState) {
                return const SizedBox();
              }
              return Column(
                children: [
                  SizedBox(
                    height: mediaQuery.size.height * 0.50,
                  ),
                  // Mostrar os produtos
                  Row(
                    children: [
                      // Botão de produto anterior
                      SizedBox(
                        width: mediaQuery.size.width * 0.13,
                      ),
                      previousButton(mediaQuery),
                      // Botão de proximo produto
                      SizedBox(
                        width: mediaQuery.size.width * 0.43,
                      ),
                      nextButton(mediaQuery)
                    ],
                  ),
                ],
              );
            },
          ),
          // Coluna com imagem de moedas entre o valor do produto
          imgCoin(mediaQuery)
        ],
      ),
    );
  }

  Widget previousButton(MediaQueryData mediaQuery) {
    return GestureDetector(
      onTap: () => {
        if (shopBloc.actualProduct != 0)
          {
            shopBloc.add(const PreviousProductInProductList()),
          }
      },
      child: SizedBox(
        height: mediaQuery.size.height * 0.08,
        width: mediaQuery.size.width * 0.16,
        child: shopBloc.actualProduct == 0
            ? null
            : Image.asset(
                'assets/images/left-arrow.png',
                fit: BoxFit.fill,
              ),
      ),
    );
  }

  Widget nextButton(MediaQueryData mediaQuery) {
    return GestureDetector(
      onTap: () {
        if (shopBloc.actualProduct != shopBloc.productList.length - 1) {
          shopBloc.add(const NextProductInProductList());
        }
      },
      child: SizedBox(
        height: mediaQuery.size.height * 0.08,
        width: mediaQuery.size.width * 0.16,
        child: shopBloc.actualProduct == shopBloc.productList.length - 1
            ? null
            : Image.asset(
                'assets/images/right-arrow.png',
                fit: BoxFit.fill,
              ),
      ),
    );
  }

  Widget exitButton(MediaQueryData mediaQuery) {
    return GestureDetector(
      onTap: () => Modular.to.navigate('../'),
      child: Row(
        children: [
          SizedBox(
            width: mediaQuery.size.width * 0.80,
          ),
          SizedBox(
            height: mediaQuery.size.height * 0.08,
            width: mediaQuery.size.width * 0.16,
            child: Image.asset(
              'assets/images/button-close.png',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  Widget imgCoin(MediaQueryData mediaQuery) {
    return Column(
      children: [
        SizedBox(
          height: mediaQuery.size.height * 0.565,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagem de moedas entre o valor do produto
            SizedBox(
              height: mediaQuery.size.height * 0.16,
              width: mediaQuery.size.width * 0.34,
              child: Image.asset(
                'assets/images/decorative-coins.png',
                fit: BoxFit.fill,
              ),
            ),
          ],
        )
      ],
    );
  }

  // Imagem mostrando o valor atual no banco do jogador
  Widget imgBank(MediaQueryData mediaQuery) {
    return Row(
      children: [
        SizedBox(
          width: mediaQuery.size.width * 0.19,
        ),
        SizedBox(
          height: mediaQuery.size.height * 0.11,
          width: mediaQuery.size.width * 0.58,
          child: Image.asset(
            'assets/images/white-coin-box-background.png',
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }

  // Botão comprar da loja,
  Widget buyButton(MediaQueryData mediaQuery) {
    // TODO(YuriOliv): transformar em um gestureDetector,
    //  com um blocBuilder por cima
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SizedBox(
        //   width: mediaQuery.size.width * 0.18,
        // ),
        SizedBox(
          height: mediaQuery.size.height * 0.12,
          width: mediaQuery.size.width * 0.65,
          child: Image.asset(
            'assets/images/purchase-button.png',
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}
