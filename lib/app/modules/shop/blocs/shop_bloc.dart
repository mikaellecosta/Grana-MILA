import 'package:bloc/bloc.dart';
import 'package:lasic_grana_flutter/app/core/blocs/base_states.dart';
import 'package:lasic_grana_flutter/app/modules/shop/blocs/shop_events.dart';
import 'package:lasic_grana_flutter/app/modules/shop/blocs/shop_states.dart';
import 'package:lasic_grana_flutter/app/modules/shop/models/product.dart';
import 'package:lasic_grana_flutter/services/remote_config_service.dart';

class ShopBloc extends Bloc<ShopEvent, AppState> {
  ShopBloc() : super(InitialState()) {
    on<CreateProductListInShopBloc>(_createProductListInShopBloc);
    on<NextProductInProductList>(_nextProductInProductList);
    on<PreviousProductInProductList>(_previousProductInProductList);
  }

  late List<Product> productList;
  int actualProduct = 0;

  // Função para criar lista de produtos
  Future<void> _createProductListInShopBloc(
    CreateProductListInShopBloc event,
    Emitter<AppState> emit,
  ) async {
    emit(CreatingProductList());

    try {
      productList = RemoteConfigService().getProductList();
      emit(SuccessfullyCreatedProductList());
    } catch (exception) {
      emit(UnableToCreateProductList());
    }
  }

  // Função para proximo item na lista de produtos
  Future<void> _nextProductInProductList(
    NextProductInProductList event,
    Emitter<AppState> emit,
  ) async {
    emit(ChangingActualProduct());

    try {
      actualProduct = actualProduct + 1;
      emit(SuccessfullyChangedActualProduct());
    } catch (exception) {
      emit(UnableToChangeActualProduct());
    }
  }

  // Função para item anterior na lista de produtos
  Future<void> _previousProductInProductList(
    PreviousProductInProductList event,
    Emitter<AppState> emit,
  ) async {
    emit(ChangingActualProduct());

    try {
      actualProduct = actualProduct - 1;
      emit(SuccessfullyChangedActualProduct());
    } catch (exception) {
      emit(UnableToChangeActualProduct());
    }
  }
}
