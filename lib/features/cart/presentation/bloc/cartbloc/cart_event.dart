abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  int productId;
  int qty;

  AddToCartEvent({required this.productId, required this.qty});
}

class GetAllCartEvent extends CartEvent{}

class IncrementQuantityEvent extends CartEvent {
  final int productId;
  final int currentQty;
  IncrementQuantityEvent({required this.productId, required this.currentQty});
}

class DecrementQuantityEvent extends CartEvent {
  final int productId;
  final int currentQty;
  DecrementQuantityEvent({required this.productId, required this.currentQty});
}



class RemoveFromCartEvent extends CartEvent {
  final int cartId;
  RemoveFromCartEvent({required this.cartId});
}
