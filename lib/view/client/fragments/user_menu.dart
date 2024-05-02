import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/viewmodel/product_viewmodel.dart';
import 'package:e_kantin/viewmodel/seller_viewmodel.dart';
import 'package:e_kantin/widget/SellerandProductScreen/seller_card.dart';
import 'package:e_kantin/widget/appbar/appbar.dart';
import 'package:e_kantin/widget/container/grid_layout.dart';
import 'package:e_kantin/widget/homeScreen/product_card_vertical.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<SellerViewModel>(context, listen: false).fetchSellers();
      Provider.of<ProductViewModel>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Menu'),
      ),
      body: Consumer2<ProductViewModel, SellerViewModel>(
        builder: (context, pvm, svm, child) {
          return pvm.isLoading || svm.sellers.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(12)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: svm.sellers
                                .map(
                                  (seller) => SellerCard(
                                      imageUrl: "assets/storeImage.png",
                                      seller: seller,
                                      productCount: 0),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            pvm.allProducts.isNotEmpty
                                ? GridLayout(
                                    itemCount: pvm.allProducts.length,
                                    itemBuilder: (_, index) {
                                      final product = pvm.allProducts[index];
                                      return ProductCardVertical(
                                        product: product,
                                      );
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
