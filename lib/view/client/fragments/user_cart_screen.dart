import 'package:e_kantin/utils/idr_formatter.dart';
import 'package:e_kantin/utils/shared_prefferences.dart';
import 'package:e_kantin/view/client/fragments/user_checkout_screen.dart';
import 'package:e_kantin/view/components/rounded_button.dart';
import 'package:e_kantin/viewmodel/cart_viewmodel.dart';
import 'package:e_kantin/widget/cartScreen/add_remove_button.dart';
import 'package:e_kantin/widget/cartScreen/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:e_kantin/widget/appbar/appbar.dart';
import 'package:e_kantin/size_config.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      appBar: CustomAppBar(
        iconColor: Colors.black,
        showBackArrow: true,
        title: Text(
          "Cart",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          final SharedPreferencesService prefs =
              SharedPreferencesService.instance;
          final storeName = prefs.getCurrentStoreName();
          return cart.items.isNotEmpty
              ? SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(getProportionateScreenWidth(16)),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => Divider(
                        color: Colors.grey[300],
                        thickness: getProportionateScreenHeight(1),
                        height: getProportionateScreenHeight(32),
                      ),
                      itemCount: cart.items.length,
                      itemBuilder: (_, index) {
                        var item = cart.items[index];
                        return Dismissible(
                          key: Key(item.product.id),
                          onDismissed: (direction) {
                            cart.removeItem(
                              item.product.id,
                            );
                          },
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              CartItem(
                                item: item,
                                storeName: storeName ?? '',
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(16),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ProductQuantityWithAddRemove(
                                    initialQuantity: item.quantity,
                                    onQuantityChange: (newQuantity) {
                                      // Here you might need to update your cart model with the new quantity
                                      cart.updateItemQuantity(
                                          cart.items[index].product.id,
                                          newQuantity);
                                      setState(() {
                                        cart.items[index].quantity =
                                            newQuantity; // Optional: Update local state if needed
                                      });
                                    },
                                  ),
                                  Text(
                                    formatCurrency(
                                      item.product.price * item.quantity,
                                    ),
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          getProportionateScreenHeight(18),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              : const Center(
                  child: Text("No products in cart"),
                );
        },
      ),
      bottomNavigationBar: Consumer<CartModel>(
        builder: (context, cart, child) {
          return cart.items.isNotEmpty
              ? Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(16),
                      vertical: getProportionateScreenHeight(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: ${formatCurrency(cart.totalPrice)}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        RoundedButton(
                          text: "Check Out",
                          press: () {
                            Get.to(() => CheckoutScreen(
                                  cart: cart.items,
                                  total: cart.totalPrice,
                                ));
                          },
                          width: SizeConfig.screenWidth * 0.3,
                          hPadding: 10,
                          vPadding: 10,
                          border: 10,
                          margin: 0,
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
