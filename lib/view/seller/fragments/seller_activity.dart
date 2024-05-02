import 'package:e_kantin/models/sellers.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/seller/fragments/order_history.dart';
import 'package:flutter/material.dart';

class SellerActivity extends StatelessWidget {
  final Seller seller;
  const SellerActivity({super.key, required this.seller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders List'),
        centerTitle: true,
        toolbarHeight: SizeConfig.screenHeight * 0.1,
        automaticallyImplyLeading: false,
      ),
      body: SellerOrderHistory(seller: seller),
    );
  }
}
