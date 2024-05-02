import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_kantin/constant.dart';
import 'package:e_kantin/models/products.dart';
import 'package:e_kantin/models/sellers.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/utils/idr_formatter.dart';
import 'package:e_kantin/view/client/fragments/user_store_screen.dart';
import 'package:e_kantin/viewmodel/seller_viewmodel.dart';
import 'package:e_kantin/widget/container/rounded_container.dart';
import 'package:e_kantin/widget/homeScreen/brand_title_verification.dart';
import 'package:e_kantin/widget/homeScreen/product_price_text.dart';
import 'package:e_kantin/widget/homeScreen/product_title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProductCardVertical extends StatelessWidget {
  final Product product;
  const ProductCardVertical({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer<SellerViewModel>(
      builder: (context, svm, child) {
        svm.fetchSellers();
        Seller? seller = svm.getSellerById(product.sellerId);
        return seller != null
            ? GestureDetector(
                onTap: () {
                  Get.to(
                    () => StoreDetailPage(
                      seller: seller,
                    ),
                  );
                },
                child: Container(
                  width: getProportionateScreenHeight(200),
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    boxShadow: [ShadowStyle.verticalProductShadow],
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: getProportionateScreenHeight(200),
                        child: RoundedContainer(
                          height: getProportionateScreenHeight(150),
                          padding: const EdgeInsets.all(8),
                          backgroundColor: kSecondaryColor,
                          child: Stack(
                            children: [
                              Center(
                                child: CachedNetworkImage(
                                  imageUrl: product.imageUrl,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(8)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProductTitleText(
                              title: product.name,
                              smallSize: true,
                              maxLines: 2,
                            ),
                            SizedBox(height: getProportionateScreenHeight(4)),
                            BrandTitleVerification(
                              title: seller.storeName,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ProductPriceText(
                                  price: formatCurrency(product.price),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}

class ShadowStyle {
  static final verticalProductShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 7,
    blurRadius: 50,
    offset: const Offset(0, 2),
  );
}
