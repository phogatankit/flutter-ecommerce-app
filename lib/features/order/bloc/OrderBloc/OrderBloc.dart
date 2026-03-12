import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/core/constants/app_url.dart';
import 'package:e_commerce/core/services/api_service.dart';

import '../../model/getOrderModel.dart';
import 'OrderEvent.dart';
import 'OrderState.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final APIService apiService;

  OrderBloc({required this.apiService}) : super(OrderInitialState()) {


    on<FetchOrdersEvent>((event, emit) async {
      emit(OrderLoadingState());
      try {
        var responseBody = await apiService.postAPI(
          url: AppUrls.Get_Order_Url,
          mBody: {"user_id": event.userId},
        );

        if (responseBody != null && (responseBody["status"] == "true" || responseBody["status"] == true)) {
          List<dynamic> rawOrdersList = responseBody["orders"] ?? [];
          List<OrderModel> parsedOrders = rawOrdersList.map((orderJson) {
            return OrderModel.fromJson(orderJson);
          }).toList();

          emit(OrderLoadedState(orders: parsedOrders));
        } else {
          emit(OrderErrorState(errorMsg: responseBody?["message"] ?? "Failed to load orders."));
        }
      } catch (e) {
        emit(OrderErrorState(errorMsg: "Error fetching orders: $e"));
      }
    });

    on<CreateNewOrderEvent>((event, emit) async {
      emit(OrderLoadingState());

      try {
        var responseBody = await apiService.postAPI(
          url: AppUrls.Create_Order_Url,
          mBody: {
            "user_id": event.userId,
            "product_id": event.productId,
            "status": event.status,
          },
        );

        if (responseBody != null && (responseBody["status"] == "true" || responseBody["status"] == true)) {
          emit(OrderCreatedSuccessState(message: responseBody["message"] ?? "Order created successfully!"));
        } else {
          emit(OrderErrorState(errorMsg: responseBody?["message"] ?? "Failed to create order."));
        }
      } catch (e) {
        emit(OrderErrorState(errorMsg: "Error creating order: $e"));
      }
    });

  }
}