
import '../../../data/model/product_model.dart';

abstract class ProductState{}

class ProductInitialState extends ProductState{}
class ProductLoadingState extends ProductState{}
class ProductLoadedState extends ProductState{
  List<ProductModel> allProduct;
  ProductLoadedState({required this.allProduct});
}
class ProductErrorState extends ProductState{
  String errorMsg;
  ProductErrorState({required this.errorMsg});
}