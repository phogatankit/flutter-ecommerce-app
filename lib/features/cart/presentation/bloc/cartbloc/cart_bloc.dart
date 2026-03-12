import 'package:e_commerce/core/constants/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/model/viewCartModel.dart';
import 'package:e_commerce/core/constants/app_url.dart';
import 'package:e_commerce/core/services/api_service.dart';
import 'package:e_commerce/features/cart/presentation/bloc/cartbloc/cart_event.dart';
import 'package:e_commerce/features/cart/presentation/bloc/cartbloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final APIService apiService;

  CartBloc({required this.apiService}) : super(CartInitialState()) {

    on<AddToCartEvent>((event, emit) async {
      emit(CartLoadingState());

      try {
        var responseBody = await apiService.postAPI(url: AppUrls.Add_To_Cart_Url, mBody: {
              "product_id": event.productId,
              "quantity": event.qty
            });

        if (responseBody["status"] == "true" || responseBody["status"] == true) {
          add(GetAllCartEvent());
        } else {
          emit(CartErrorState(errorMsg: responseBody["message"] ?? "Unknown Error"));
        }
      } catch (e) {
        emit(CartErrorState(errorMsg: e.toString()));
      }
    });

    on<GetAllCartEvent>((event, emit) async {
      emit(CartLoadingState());

      try {
        var responseBody = await apiService.getAPI(url: AppUrls.View_Cart_Url);

        if (responseBody["status"] == "true" || responseBody["status"] == true) {

          List<dynamic> data = responseBody["data"] ?? [];
          List<ViewCart> mCartViewModel = data.map((eachMap) {
            return ViewCart.fromJson(eachMap);
          }).toList();

          emit(CartLoadedState(mViewCart: mCartViewModel));

        } else {
          emit(CartErrorState(errorMsg: responseBody["message"] ?? "Failed to fetch cart"));
        }
      } catch (e) {
        emit(CartErrorState(errorMsg: e.toString()));
      }
    });

    on<IncrementQuantityEvent>((event, emit) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String savedIdString = prefs.getString(AppConstants.prefUserID) ?? prefs.getString("ACTUAL_USER_ID") ?? "1";
        int userId = int.tryParse(savedIdString) ?? 1;

        var responseBody = await apiService.postAPI(url: AppUrls.Add_To_Cart_Url, mBody: {
              "user_id": userId,
              "product_id": event.productId,
              "quantity": 1
            });


        if (responseBody != null && (responseBody["status"] == "true" || responseBody["status"] == true)) {
          add(GetAllCartEvent());
        } else {}
      } catch (e) {
        print("Error incrementing BLoC crash: $e");
      }
    });

    on<DecrementQuantityEvent>((event, emit) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String savedIdString = prefs.getString(AppConstants.prefUserID) ?? prefs.getString("ACTUAL_USER_ID") ?? "1";
        int userId = int.tryParse(savedIdString) ?? 1;

        var responseBody = await apiService.postAPI(url: AppUrls.Decrement_Cart_Url, mBody: {
              "user_id": userId,
              "product_id": event.productId,
              "quantity": 1
            });

        if (responseBody != null && (responseBody["status"] == "true" || responseBody["status"] == true)) {
          add(GetAllCartEvent());
        } else {}
      } catch (e) {
        print("Error decrementing BLoC crash: $e");
      }
    });


    on<RemoveFromCartEvent>((event, emit) async {
      try {
        var response = await apiService.postAPI(url: AppUrls.Delete_Cart_Url, mBody: {"cart_id": event.cartId});

        if (response["status"] == true || response["status"] == "true") {
          add(GetAllCartEvent());
        } else {
          emit(CartErrorState(errorMsg: response["message"]));
        }
      } catch (e) {
        emit(CartErrorState(errorMsg: e.toString()));
      }
    });
  }
}


