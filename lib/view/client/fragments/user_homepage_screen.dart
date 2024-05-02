import 'package:flutter/material.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/widget/container/grid_layout.dart';
import 'package:e_kantin/widget/homeScreen/home_appbar.dart';
import 'package:e_kantin/widget/homeScreen/product_card_vertical.dart';
import 'package:e_kantin/widget/homeScreen/promo_slider.dart';
import 'package:e_kantin/widget/container/search_container.dart';
import 'package:e_kantin/widget/container/primary_header_container.dart';
import 'package:provider/provider.dart';
import 'package:e_kantin/viewmodel/product_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<ProductViewModel>(context, listen: false).fetchProducts();
    });
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
                    height: getProportionateScreenHeight(10),
                  ),
                  const HomeAppBar(),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  const SearchContainer(
                    text: 'Search your favorite food',
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(32),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(16)),
              child: const PromoSlider(
                banners: [
                  'assets/banner/banner1.png',
                  'assets/banner/banner2.png',
                  'assets/banner/banner3.png',
                ],
              ),
            ),
            Consumer<ProductViewModel>(
              builder: (context, model, child) {
                return !model.isLoading
                    ? GridLayout(
                        itemCount: model.limitedProducts.length,
                        itemBuilder: (_, index) {
                          final product = model.limitedProducts[index];
                          return ProductCardVertical(
                            product: product,
                          );
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
