import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_bloc.dart';
import 'package:lasic_grana_flutter/app/core/blocs/user_data_events.dart';
import 'package:lasic_grana_flutter/app/core/languages/brazilian_portuguese.dart';
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
              _imgBank(mediaQuery),
              SizedBox(
                height: mediaQuery.size.height * 0.61,
              ),
              // Botão comprar da loja,

              BlocBuilder<ShopBloc, AppState>(
                  bloc: shopBloc,
                  builder: (context, state) {
                    if (state is InitialState) {
                      return const SizedBox();
                    }

                    return BlocBuilder<UserDataBloc, AppState>(
                        bloc: userDataBloc,
                        builder: (context, state) {
                          bool haveMoneyToBuyItem = false;
                          bool alreadyAdquiredItem = false;

                          if (userDataBloc.isSaved) {
                            // Variaveis para melhor legibilidade do if abaixo
                            final coins = userDataBloc.userData.coins;
                            final productsPurchased =
                                userDataBloc.userData.productsPurchased;
                            final actualProduct =
                                shopBloc.productList[shopBloc.actualProduct];

                            if (productsPurchased
                                .contains(actualProduct.name)) {
                              alreadyAdquiredItem = true;
                            } else if (coins >= actualProduct.value) {
                              haveMoneyToBuyItem = true;
                            }
                          }

                          return GestureDetector(
                            onTap: () => {
                              if (alreadyAdquiredItem)
                                {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => Stack(
                                      children: [
                                        _whiteBoxForAlertDialog(mediaQuery),
                                        _alertTittle(mediaQuery),
                                        _alertInformation(
                                            mediaQuery,
                                            BrazilianPortuguese()
                                                .itemAlreadyAdquired),
                                        _exitAlertOkButton(mediaQuery),
                                      ],
                                    ),
                                  ),
                                }
                              else if (haveMoneyToBuyItem)
                                {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => Stack(
                                      children: [
                                        _whiteBoxForAlertDialog(mediaQuery),
                                        _alertTittle(mediaQuery),
                                        _alertInformation(
                                            mediaQuery,
                                            BrazilianPortuguese()
                                                .confirmationBuyItem),
                                        _yesNoButton(mediaQuery),
                                      ],
                                    ),
                                  ),
                                }
                              else
                                {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => Stack(
                                      children: [
                                        _whiteBoxForAlertDialog(mediaQuery),
                                        _alertTittle(mediaQuery),
                                        _alertInformation(
                                            mediaQuery,
                                            BrazilianPortuguese()
                                                .insuficientCoins),
                                        _exitAlertOkButton(mediaQuery),
                                      ],
                                    ),
                                  ),
                                }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: mediaQuery.size.height * 0.12,
                                  width: mediaQuery.size.width * 0.65,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.asset(
                                        alreadyAdquiredItem
                                            ? 'assets/images/purchase-button-empty.png'
                                            : haveMoneyToBuyItem
                                                ? 'assets/images/purchase-button.png'
                                                : 'assets/images/purchase-locked-button-empty.png',
                                        fit: BoxFit.fill,
                                      ),
                                      Positioned(
                                        top: mediaQuery.size.width * 0.07,
                                        left: mediaQuery.size.width * 0.07,
                                        child: SizedBox(
                                          width: mediaQuery.size.width * 0.3,
                                          child: Text(
                                            alreadyAdquiredItem
                                                ? 'Adquirido'
                                                : haveMoneyToBuyItem
                                                    ? ''
                                                    : 'Comprar',
                                            style: const TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  })
            ],
          ),

          // Column com valor do banco do usuario
          BlocBuilder<UserDataBloc, AppState>(
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
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
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
              _exitButton(mediaQuery)
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                              ),
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
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
                      _previousButton(mediaQuery),
                      // Botão de proximo produto
                      SizedBox(
                        width: mediaQuery.size.width * 0.43,
                      ),
                      _nextButton(mediaQuery)
                    ],
                  ),
                ],
              );
            },
          ),
          // Coluna com imagem de moedas entre o valor do produto
          _imgCoin(mediaQuery)
        ],
      ),
    );
  }

  Widget _previousButton(MediaQueryData mediaQuery) {
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

  Widget _nextButton(MediaQueryData mediaQuery) {
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

  Widget _exitButton(MediaQueryData mediaQuery) {
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

  Widget _imgCoin(MediaQueryData mediaQuery) {
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
  Widget _imgBank(MediaQueryData mediaQuery) {
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

  Widget _whiteBoxForAlertDialog(MediaQueryData mediaQuery) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.03),
          child: Image.asset('assets/images/white-box-background.png'),
        ),
      ],
    );
  }

  Widget _yesNoButton(MediaQueryData mediaQuery) {
    return Column(
      children: [
        SizedBox(
          height: mediaQuery.size.height * 0.55,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 1° botão do alert dialog
            GestureDetector(
              onTap: () {
                _yesButtonConfirmation();
                userDataBloc.add(const UpdateUserData());
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: mediaQuery.size.height * 0.06,
                    child:
                        Image.asset('assets/images/blue-button-background.png'),
                  ),
                  const Material(
                    color: Colors.transparent,
                    child: Text(
                      'Sim',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Espaço entre botões
            SizedBox(
              width: mediaQuery.size.width * 0.1,
            ),
            // 2° botão do alert dialog
            GestureDetector(
              onTap: () {
                Modular.to.pop();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: mediaQuery.size.height * 0.06,
                    child:
                        Image.asset('assets/images/blue-button-background.png'),
                  ),
                  const Material(
                    color: Colors.transparent,
                    child: Text(
                      'Não',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _alertTittle(MediaQueryData mediaQuery) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Column(children: [
        SizedBox(
          height: mediaQuery.size.height * 0.39,
        ),
        const Material(
            color: Colors.transparent,
            child: Text(
              'Alerta',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ))
      ])
    ]);
  }

  Widget _alertInformation(MediaQueryData mediaQuery, String informationText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.1),
      child: Column(
        children: [
          SizedBox(
            height: mediaQuery.size.height * 0.47,
          ),
          Material(
            color: Colors.transparent,
            child: Column(
              children: [
                SizedBox(
                  width: mediaQuery.size.width,
                  child: Text(
                    informationText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _yesButtonConfirmation() {
    // Variaveis para melhor legibilidade do if abaixo
    final coins = userDataBloc.userData.coins;
    final actualProductValue =
        shopBloc.productList[shopBloc.actualProduct].value;

    if (coins >= actualProductValue) {
      userDataBloc.add(
          BuyProduct(product: shopBloc.productList[shopBloc.actualProduct]));
      userDataBloc.add(const UpdateUserData());

      Modular.to.pop();
    }
  }

  Widget _exitAlertOkButton(MediaQueryData mediaQuery) {
    return Column(
      children: [
        SizedBox(
          height: mediaQuery.size.height * 0.55,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 1° botão do alert dialog
            GestureDetector(
              onTap: () {
                Modular.to.pop();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: mediaQuery.size.height * 0.06,
                    child:
                        Image.asset('assets/images/blue-button-background.png'),
                  ),
                  const Material(
                    color: Colors.transparent,
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
// Botão comprar da loja
// Widget buyButton(MediaQueryData mediaQuery) {

// }
