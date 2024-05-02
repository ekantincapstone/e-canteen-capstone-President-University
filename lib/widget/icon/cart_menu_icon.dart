import 'package:e_kantin/constant.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/viewmodel/cart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class CartCounterIcon extends StatelessWidget {
  const CartCounterIcon({
    super.key,
    required this.onPressed,
    this.iconColor = kSecondaryColor,
  });

  final VoidCallback onPressed;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(
      builder: (context, cart, child) {
        return Stack(
          children: [
            IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Iconsax.shopping_bag,
                  color: iconColor,
                )),
            Positioned(
              right: 0,
              child: Container(
                width: getProportionateScreenHeight(18),
                height: getProportionateScreenHeight(18),
                decoration: BoxDecoration(
                  color: kButtonColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    cart.totalCount.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .apply(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
