class AppUrls{
  static const String base_url = "https://ecomapi.projectnest.co.in";
  ///login
  static const String login_url = "$base_url/ecommerce-api/user/login";
  ///signUp
  static const String sign_up_url = "$base_url/ecommerce-api/user/registration";
  ///cat
  static const String cat_url = "$base_url/ecommerce-api/categories";
  ///product
  static const String product_url = "$base_url/ecommerce-api/products";

  /// Add to Cart
  static const String Add_To_Cart_Url = "$base_url/ecommerce-api/add-to-cart";
/// view cart
  static const String View_Cart_Url = "$base_url/ecommerce-api/product/view-cart";

  ///
  static const String Decrement_Cart_Url = "$base_url/ecommerce-api/product/decrement-quantity";
  /// delete
  static const String Delete_Cart_Url = "$base_url/ecommerce-api/product/delete-cart";
/// Create Order
 static const String Create_Order_Url = "$base_url/ecommerce-api/product/create-order";
 /// profile
  static const String Profile_Url = "$base_url/ecommerce-api/user/profile";

  /// Get Orders
  static const String Get_Order_Url = "$base_url/ecommerce-api/product/get-order";
}