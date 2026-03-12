import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../order/bloc/OrderBloc/OrderBloc.dart';
import '../../../order/bloc/OrderBloc/OrderEvent.dart';
import '../../../order/bloc/OrderBloc/OrderState.dart';
import '../bloc/cartbloc/cart_bloc.dart';
import '../bloc/cartbloc/cart_event.dart';
import '../bloc/cartbloc/cart_state.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartBloc>().add(GetAllCartEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        // CartBloc Consumer handles loading the cart items
        child: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMsg),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            double subtotal = 0.0;
            if (state is CartLoadedState) {
              for (var item in state.mViewCart) {
                double itemPrice = double.tryParse(item.price.toString()) ?? 0.0;
                int itemQty = int.tryParse(item.quantity.toString()) ?? 1;
                subtotal += (itemPrice * itemQty);
              }
            }

            double ALLTOTAL = subtotal;

            // ---> FIX 1: Wrap the Column in an OrderBloc Listener! <---
            return BlocListener<OrderBloc, OrderState>(
              listener: (context, orderState) {
                if (orderState is OrderCreatedSuccessState) {
                  // SUCCESS! Show a green snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(orderState.message),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  // Optional: Add Navigator.push here to go to an "Order Success" screen!

                } else if (orderState is OrderErrorState) {
                  // ERROR! Show a red snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(orderState.errorMsg),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Column(
                children: [
                  const Text(
                    "My Cart",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state is CartLoadingState) {
                          return const Center(child: CircularProgressIndicator(color: Color(0xFFFF6600)));
                        }

                        if (state is CartErrorState) {
                          return Center(child: Text('Your Cart is Empty'));
                        }

                        if (state is CartLoadedState) {
                          if (state.mViewCart.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[300]),
                                  const SizedBox(height: 16),
                                  Text("Your Cart is Empty", style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                                ],
                              ),
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.all(20),
                            itemCount: state.mViewCart.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 20),
                            itemBuilder: (context, index) {
                              final item = state.mViewCart[index];
                              return CartItemCard(
                                cartId: item.id ?? 0,
                                productId: item.productId ?? 0,
                                imageUrl: item.image ?? "",
                                title: item.name ?? "",
                                category: "",
                                price: double.tryParse(item.price.toString()) ?? 0.0,
                                qty: int.tryParse(item.quantity.toString()) ?? 1,
                              );
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5)),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F3F3),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Enter Discount Code",
                              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              suffixIcon: TextButton(
                                onPressed: () {},
                                child: const Text("Apply", style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Subtotal", style: TextStyle(color: Colors.grey, fontSize: 16)),
                            Text("\$${ALLTOTAL.toStringAsFixed(2)}", style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: Color(0xFFEEEEEE)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                            Text("\$${ALLTOTAL.toStringAsFixed(2)}", style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (state is CartLoadedState && state.mViewCart.isNotEmpty) {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                String myUserId = prefs.getString("ACTUAL_USER_ID") ?? "1";
                                int parsedId = int.tryParse(myUserId) ?? 1;

                                final firstCartItem = state.mViewCart.first;
                                int productIdToBuy = firstCartItem.productId ?? firstCartItem.id ?? 0;

                                context.read<OrderBloc>().add(CreateNewOrderEvent(userId: parsedId, productId: productIdToBuy));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Your cart is empty!"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6600),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text("Checkout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}


class CartItemCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;
  final double price;
  final int qty;
  final int productId;
  final int cartId;

  const CartItemCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.price,
    required this.qty,
    required this.productId,
    required this.cartId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 5),
                Text(category, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 10),
                Text("\$${price.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  context.read<CartBloc>().add(RemoveFromCartEvent(cartId: cartId));
                },
                child: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFFF6600),
                  size: 20,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          if (qty > 1) {
                            context.read<CartBloc>().add(
                                DecrementQuantityEvent(productId: productId, currentQty: qty)
                            );
                          }
                        },
                        icon: const Icon(Icons.minimize_rounded)
                    ),
                    const SizedBox(width: 8),

                    Text("$qty", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),

                    const SizedBox(width: 8),
                    IconButton(
                        onPressed: () {
                          context.read<CartBloc>().add(IncrementQuantityEvent(productId: productId, currentQty: qty));
                        },
                        icon: const Icon(Icons.add)
                    ),
                  ],
                ),
              )

            ],
          )
        ],
      ),
    );
  }
}