class ViewCart {
  int? id;
  int? productId;
  String? name;
  String? price;
  int? quantity;
  String? image;

  ViewCart(
      {this.id,
        this.productId,
        this.name,
        this.price,
        this.quantity,
        this.image});

  ViewCart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    name = json['name'];
    price = json['price'];
    quantity = json['quantity'];
    image = json['image'];
  }

 /* Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['image'] = this.image;
    return data;
  }*/
}
