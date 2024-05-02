import 'package:e_kantin/models/sellers.dart';
import 'package:e_kantin/utils/idr_formatter.dart';
import 'package:e_kantin/view/client/fragments/user_cart_screen.dart';
import 'package:e_kantin/viewmodel/cart_viewmodel.dart';
import 'package:e_kantin/viewmodel/product_viewmodel.dart';
import 'package:e_kantin/widget/container/primary_header_container.dart';
import 'package:e_kantin/widget/icon/circular_icon.dart';
import 'package:flutter/material.dart';
import 'package:e_kantin/models/products.dart';
import 'package:e_kantin/constant.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/widget/container/rounded_container.dart';
import 'package:e_kantin/widget/container/rounded_image.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class HorizontalCard extends StatelessWidget {
  final Product product;
  final String storeName;

  const HorizontalCard({
    super.key,
    required this.storeName,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(10),
        vertical: getProportionateScreenHeight(6),
      ),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(getProportionateScreenWidth(10)),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .apply(color: kButtonColor),
                    ),
                    SizedBox(height: getProportionateScreenHeight(4)),
                    Text(
                      product.description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(color: kButtonColor),
                    ),
                    SizedBox(height: getProportionateScreenHeight(4)),
                    Text(
                      product.description,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: Colors.grey),
                    ),
                    SizedBox(height: getProportionateScreenHeight(4)),
                    Text(
                      formatCurrency(product.price),
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .apply(color: kMainColor),
                    ),
                  ],
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(16)),
              Column(
                children: [
                  RoundedContainer(
                    height: getProportionateScreenHeight(64),
                    width: getProportionateScreenWidth(64),
                    child: const RoundedImage(
                      imageUrl: 'assets/makananProduct.png',
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(8)),
                  Container(
                    decoration: BoxDecoration(
                      color: kButtonColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () => context.read<CartModel>().addToCart(
                            product,
                            storeName,
                          ),
                      child: Text(
                        'Add',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .apply(color: Colors.white),
                      ),
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

class StoreDetailPage extends StatefulWidget {
  final Seller seller;
  const StoreDetailPage({super.key, required this.seller});

  @override
  State<StoreDetailPage> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAsync();
    });
  }

  void initAsync() async {
    await Provider.of<ProductViewModel>(context, listen: false)
        .fetchProductsBySellerId(widget.seller.id);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeaderContainer(
              child: Column(
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(50),
                  ),
                  ListTile(
                    leading: CircularIcon(
                      icon: Iconsax.verify,
                      size: getProportionateScreenHeight(32),
                      color: kMainColor,
                      backgroundColor: kSecondaryColor,
                    ),
                    title: Text(
                      widget.seller.storeName,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .apply(color: kSecondaryColor),
                    ),
                    subtitle: Text(
                      "0${widget.seller.phone}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(color: kSecondaryColor),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(32)),
                ],
              ),
            ),
            Consumer2<CartModel, ProductViewModel>(
              builder: (context, cart, pvm, child) {
                return pvm.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : pvm.products.isNotEmpty
                        ? Column(
                            children: List.generate(
                              pvm.products.length,
                              (index) {
                                return HorizontalCard(
                                  product: pvm.products[index],
                                  storeName: widget.seller.storeName,
                                );
                              },
                            ),
                          )
                        : const Center(
                            child:
                                Text("This store doesn't have a product yet!"),
                          );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<CartModel>(
        builder: (context, cart, child) {
          return cart.totalCount > 0
              ? FloatingActionButton.extended(
                  onPressed: () {
                    Get.to(() => const CartScreen());
                  },
                  backgroundColor: kButtonColor,
                  label: Container(
                    width: SizeConfig.screenWidth * 0.8,
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "${cart.totalCount} item(s)",
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(12),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  cart.currentStoreName ?? '',
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(12),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      formatCurrency(cart.totalPrice),
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(15),
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(10),
                            ),
                            const Icon(
                              Iconsax.shopping_bag,
                              color: Colors.white,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }
}
