import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/OrderBloc/OrderBloc.dart';
import '../bloc/OrderBloc/OrderEvent.dart';
import '../bloc/OrderBloc/OrderState.dart';
import '../model/getOrderModel.dart';
class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Get the decoded ID we saved earlier
      String myUserId = prefs.getString("ACTUAL_USER_ID") ?? "1";
      int parsedId = int.tryParse(myUserId) ?? 1;

      context.read<OrderBloc>().add(FetchOrdersEvent(userId: parsedId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            // --- Header ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "ORDER",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.black
                    ),
                  ),

                ],
              ),
            ),

            // --- Body (BLoC Consumer) ---
            Expanded(
              child: BlocConsumer<OrderBloc, OrderState>(
                listener: (context, state) {
                  if (state is OrderErrorState) {
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
                  if (state is OrderLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFFFF6600)),
                    );
                  }

                  if (state is OrderErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 10),
                          Text(state.errorMsg, style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  if (state is OrderLoadedState) {
                    if (state.orders.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey),
                            SizedBox(height: 15),
                            Text("You have no orders yet.", style: TextStyle(color: Colors.grey, fontSize: 16)),
                          ],
                        ),
                      );
                    }

                    // --- List of Order Tiles ---
                    return ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: state.orders.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        return _buildOrderTile(state.orders[index]);
                      },
                    );
                  }

                  // Fallback empty state
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Reusable Order Tile Widget ---
  Widget _buildOrderTile(OrderModel order) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Order Number & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order #${order.orderNumber ?? 'N/A'}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Confirmed",
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Row 2: Date
          Text(
            order.createdAt ?? "",
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(color: Color(0xFFEEEEEE), thickness: 1),
          ),

          if (order.products != null && order.products!.isNotEmpty)
            ListView.separated(
              shrinkWrap: true, // Important for ListView inside a Column
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.products!.length,
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemBuilder: (context, productIndex) {
                final product = order.products![productIndex];
                return Row(
                  children: [
                    // Product Image
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(product.image ?? "https://via.placeholder.com/50"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),

                    // Product Name & Qty
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name ?? "Unknown Item",
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Qty: ${product.quantity ?? 1}",
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    // Product Price
                    Text(
                      "\$${product.price ?? '0.00'}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                );
              },
            ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(color: Color(0xFFEEEEEE), thickness: 1),
          ),

          // Row 4: Total Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Amount", style: TextStyle(color: Colors.grey, fontSize: 14)),
              Text(
                "\$${order.totalAmount ?? '0.00'}",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6600)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


}