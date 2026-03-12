abstract class OrderEvent {}

// Your existing event
class FetchOrdersEvent extends OrderEvent {
  final int userId;
  FetchOrdersEvent({required this.userId});
}

// ---> ADD THIS NEW EVENT <---
class CreateNewOrderEvent extends OrderEvent {
  final int userId;
  final int productId;
  final int status;

  CreateNewOrderEvent({
    required this.userId,
    required this.productId,
    this.status = 1, // Defaulting to 1 as per your Postman body
  });
}