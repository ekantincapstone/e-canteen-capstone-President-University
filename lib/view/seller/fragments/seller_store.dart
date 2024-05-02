import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_kantin/constant.dart';
import 'package:e_kantin/models/products.dart';
import 'package:e_kantin/models/sellers.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/seller/add_product.dart';
import 'package:e_kantin/view/seller/components/product_item.dart';
import 'package:e_kantin/viewmodel/product_viewmodel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProductList extends StatefulWidget {
  final Seller seller;
  const ProductList({super.key, required this.seller});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late Future<List<Product>> _productsFuture;

  void getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.getToken().then((token) {
      saveToken(token!, widget.seller.id);
    });
  }

  void saveToken(String token, String sellerId) async {
    try {
      await FirebaseFirestore.instance
          .collection("tokens")
          .doc(sellerId)
          .set({'token': token});
    } catch (e) {
      print('error : $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
    getToken();
  }

  Future<List<Product>> fetchProducts() async {
    ProductViewModel pvm = ProductViewModel();
    await pvm.fetchProductsBySellerId(widget.seller.id);
    return pvm.products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Store"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: SizeConfig.screenHeight * 0.1,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddProduct(seller: widget.seller),
              ),
            ),
            child: Container(
              height: getProportionateScreenHeight(50),
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
              ),
              decoration: const BoxDecoration(
                color: kButtonColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Add Product",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Icon(Iconsax.add_square, color: Colors.white)
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: getProportionateScreenHeight(30),
          top: getProportionateScreenHeight(16),
          left: getProportionateScreenWidth(20),
          right: getProportionateScreenWidth(20),
        ),
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text("No Products"));
            } else {
              return ListView(
                children: snapshot.data!
                    .map((product) => ProductItem(product: product))
                    .toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
