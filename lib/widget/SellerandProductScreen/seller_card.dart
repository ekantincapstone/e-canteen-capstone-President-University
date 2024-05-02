import 'package:e_kantin/models/sellers.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/client/fragments/user_store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerCard extends StatelessWidget {
  final String imageUrl;
  final Seller seller;
  final int productCount;

  const SellerCard({
    super.key,
    required this.imageUrl,
    required this.seller,
    required this.productCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: getProportionateScreenWidth(10)),
      child: GestureDetector(
        onTap: () => Get.to(() => StoreDetailPage(seller: seller)),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image(
                  image: AssetImage(imageUrl),
                  width: getProportionateScreenHeight(50),
                  height: getProportionateScreenHeight(50),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      seller.storeName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
