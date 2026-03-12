class OrderModel {
  int? id;
  String? totalAmount;
  String? orderNumber;
  String? status;
  String? createdAt;
  List<OrderProductModel>? products;

  OrderModel({
    this.id,
    this.totalAmount,
    this.orderNumber,
    this.status,
    this.createdAt,
    this.products,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      totalAmount: json['total_amount']?.toString(),
      orderNumber: json['order_number']?.toString(),
      status: json['status']?.toString(),
      createdAt: json['created_at'],
      products: json['product'] != null
          ? (json['product'] as List).map((i) => OrderProductModel.fromJson(i)).toList()
          : [],
    );
  }
}

class OrderProductModel {
  int? id;
  String? name;
  int? quantity;
  String? price;
  String? image;

  OrderProductModel({
    this.id,
    this.name,
    this.quantity,
    this.price,
    this.image,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price']?.toString(),
      image: json['image'],
    );
  }
}