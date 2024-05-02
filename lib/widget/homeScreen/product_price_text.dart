import "package:e_kantin/size_config.dart";
import "package:flutter/material.dart";

class ProductPriceText extends StatelessWidget {
  const ProductPriceText({
    super.key,
    required this.price,
    this.maxLines = 1,
    this.lineThrough = false,
  });

  final String price;
  final int maxLines;
  final bool lineThrough;

  @override
  Widget build(BuildContext context) {
    return Text(
      price,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: getProportionateScreenHeight(16),
      ),
    );
  }
}
