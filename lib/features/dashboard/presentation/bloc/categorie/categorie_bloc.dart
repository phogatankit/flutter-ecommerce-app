import 'package:e_commerce/core/constants/app_url.dart';
import 'package:e_commerce/core/services/api_service.dart';
import 'package:e_commerce/features/dashboard/data/model/cat_model.dart';
import 'package:e_commerce/features/dashboard/presentation/bloc/categorie/Categorie_state.dart';
import 'package:e_commerce/features/dashboard/presentation/bloc/categorie/categorie_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategorieBloc extends Bloc<CategoryEvent,CategoryState>{
  APIService apiService;
  CategorieBloc({required this .apiService}):super(CategoryInitialState()){

    on<GetAllCategoryEvent>((event,emit)async{
        emit(CategoryLoadingState());
        try{
         var responseBody= await apiService.getAPI(url: AppUrls.cat_url);
         if(responseBody["status"]==true){


           List<dynamic> mCatMap = responseBody["data"];
           List<CatModel> mCatModel = [];
           for(Map<String, dynamic> eachMap in mCatMap){
             mCatModel.add(CatModel.fromJson(eachMap));
           }

           emit(CategoryLoadedState(mCat: mCatModel));

         }else{
           emit(CategoryErrorState(errorMsg:responseBody["message"] ));
         }
        }catch(e){
          emit(CategoryErrorState(errorMsg: e.toString()));
        }
    });



  }
}