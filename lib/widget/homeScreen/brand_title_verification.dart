import 'package:e_kantin/constant.dart';
import 'package:e_kantin/size_config.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BrandTitleVerification extends StatelessWidget {
  const BrandTitleVerification({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .apply(color: Colors.grey),
          ),
        ),
        const SizedBox(width: 4),
        Icon(
          Iconsax.verify5,
          color: kMainColor,
          size: getProportionateScreenHeight(16),
        ),
      ],
    );
  }
}
