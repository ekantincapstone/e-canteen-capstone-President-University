import 'package:e_kantin/size_config.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:e_kantin/constant.dart';
import 'package:e_kantin/widget/icon/circular_icon.dart';

class ProductQuantityWithAddRemove extends StatefulWidget {
  final int initialQuantity;
  final Function(int quantity) onQuantityChange;

  const ProductQuantityWithAddRemove({
    super.key,
    required this.initialQuantity,
    required this.onQuantityChange,
  });

  @override
  State<ProductQuantityWithAddRemove> createState() =>
      _ProductQuantityWithAddRemoveState();
}

class _ProductQuantityWithAddRemoveState
    extends State<ProductQuantityWithAddRemove> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
    widget.onQuantityChange(quantity);
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
      widget.onQuantityChange(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _decrementQuantity,
          child: CircularIcon(
            icon: Iconsax.minus,
            size: getProportionateScreenHeight(30),
            color: kButtonColor,
            backgroundColor: kSecondaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          quantity.toString(),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: _incrementQuantity,
          child: CircularIcon(
            icon: Iconsax.add,
            size: getProportionateScreenHeight(30),
            color: kSecondaryColor,
            backgroundColor: kMainColor,
          ),
        ),
      ],
    );
  }
}
