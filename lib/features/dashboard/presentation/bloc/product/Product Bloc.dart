import 'package:e_commerce/core/constants/app_url.dart';
import 'package:e_commerce/core/services/api_service.dart';
import 'package:e_commerce/features/dashboard/data/model/product_model.dart';
import 'package:e_commerce/features/dashboard/presentation/bloc/product/Product%20Event.dart';
import 'package:e_commerce/features/dashboard/presentation/bloc/product/product%20State.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState>{

  APIService apiService ;

  ProductBloc({required this.apiService}) : super(ProductInitialState()){

    on<FetchAllProductEvent>((event , emit )async{
      emit(ProductLoadingState());
      try{
       var responseBody = await apiService.postAPI(url: AppUrls.product_url);

       if(responseBody["status"]){
         List<ProductModel> mProducts = [];
         List<dynamic> data = responseBody["data"];

         for(Map<String,dynamic> eachMap in data ){
           mProducts.add(ProductModel.fromJson(eachMap));
         }
         emit(ProductLoadedState(allProduct: mProducts));

       }else{
         emit(ProductErrorState(errorMsg: responseBody["message"]));
       }

      }catch(e){
        emit(ProductErrorState(errorMsg: e.toString()));
      }

    });


  }



}