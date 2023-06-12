abstract class ShopEvent {}

// Evento para criar lista de produtos em ShopBloc
class CreateProductListInShopBloc implements ShopEvent {
  const CreateProductListInShopBloc();
}

// Evento para passar para proximo produto
class NextProductInProductList implements ShopEvent {
  const NextProductInProductList();
}

// Evento para passar para produto anteriror
class PreviousProductInProductList implements ShopEvent {
  const PreviousProductInProductList();
}


