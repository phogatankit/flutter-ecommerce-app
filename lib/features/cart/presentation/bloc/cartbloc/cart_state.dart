import 'package:e_commerce/features/cart/data/model/viewCartModel.dart';

abstract class CartState {}

class CartInitialState extends CartState {}
class CartLoadingState extends CartState {}
class CartLoadedState extends CartState {
  List<ViewCart>   mViewCart;
  CartLoadedState({ required this.mViewCart});
}

class CartErrorState extends CartState {
  String errorMsg;
  CartErrorState({required this.errorMsg});
}
