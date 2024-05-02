import 'package:e_kantin/models/orders.dart' as mo;
import 'package:e_kantin/models/sellers.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/seller/components/order_item.dart';
import 'package:e_kantin/viewmodel/order_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellerOrderHistory extends StatefulWidget {
  final Seller seller;
  const SellerOrderHistory({super.key, required this.seller});

  @override
  State<SellerOrderHistory> createState() => _SellerOrderHistoryState();
}

class _SellerOrderHistoryState extends State<SellerOrderHistory> {
  late Future<List<mo.Order>> ordersFuture;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isLoaded) {
      ordersFuture = fetchOrders();
      isLoaded = true;
    }
  }

  Future<List<mo.Order>> fetchOrders() async {
    final ovm = Provider.of<OrderViewModel>(context, listen: true);
    await ovm.fetchOrdersForSeller(widget.seller.id);
    return ovm.orders;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<mo.Order>>(
      future: ordersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<mo.Order> orders = snapshot.data!;
          return body(orders);
        } else {
          return const Center(
            child: Text(
              'No accounts available. Please add your Bank Accounts in profile page.',
            ),
          );
        }
      },
    );
  }

  Widget body(List<mo.Order> orders) {
    return orders.isEmpty
        ? const Center(
            child: Text("No Orders"),
          )
        : Padding(
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(16),
              horizontal: getProportionateScreenHeight(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: orders
                    .map(
                      (order) => OrderItem(order: order),
                    )
                    .toList(),
              ),
            ),
          );
  }
}
