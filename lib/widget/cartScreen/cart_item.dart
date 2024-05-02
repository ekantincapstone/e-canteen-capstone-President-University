import 'package:e_kantin/models/cart_product.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/widget/container/rounded_image.dart';
import 'package:e_kantin/widget/homeScreen/brand_title_verification.dart';
import 'package:e_kantin/widget/homeScreen/product_title_text.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String storeName;
  final CartProduct item;
  const CartItem({
    super.key,
    required this.item,
    required this.storeName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RoundedImage(
          imageUrl: "assets/logo.png",
          width: getProportionateScreenHeight(60),
          height: getProportionateScreenHeight(60),
          padding: const EdgeInsets.all(8),
        ),
        SizedBox(
          width: getProportionateScreenHeight(16),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BrandTitleVerification(
                title: storeName,
              ),
              Flexible(
                child: ProductTitleText(
                  title: item.product.name,
                  maxLines: 1,
                ),
              ),
              Text(
                item.product.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        )
      ],
    );
  }
}
