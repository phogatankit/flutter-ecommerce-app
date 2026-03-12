import '../../../data/model/cat_model.dart';

abstract class CategoryState{}

class CategoryInitialState extends CategoryState{}
class CategoryLoadingState extends CategoryState{}
class CategoryLoadedState extends CategoryState{
  List<CatModel>  mCat;
  CategoryLoadedState({required this.mCat});
}
class CategoryErrorState extends CategoryState{
  String errorMsg;
  CategoryErrorState({required this.errorMsg});
}