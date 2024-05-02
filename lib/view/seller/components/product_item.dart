import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_kantin/models/products.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/utils/idr_formatter.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: getProportionateScreenHeight(10),
      ),
      child: GestureDetector(
        onTap: () => {},
        child: Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight * 0.15,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.screenWidth * 0.03,
            vertical: SizeConfig.screenHeight * 0.016,
          ),
          decoration: BoxDecoration(
            color: Colors.white70,
            border: Border.all(color: Colors.black12),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: SizeConfig.screenHeight * 0.12,
                width: SizeConfig.screenHeight * 0.12,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  // image: DecorationImage(
                  //   image: NetworkImage(product.imageUrl),
                  //   fit: BoxFit.cover,
                  // ),
                ),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(Iconsax.warning_2),
                ),
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.05,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: SizeConfig.screenHeight * 0.25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          product.description,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: getProportionateScreenHeight(12),
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Text(
                    formatCurrency(product.price),
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(14),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
