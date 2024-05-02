import 'package:e_kantin/constant.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.search_normal,
  });

  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kSecondaryColor.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Iconsax.search_normal, color: Colors.grey),
              const SizedBox(
                width: 16,
              ),
              Text('Search your favorite food',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .apply(color: Colors.grey)),
            ],
          )),
    );
  }
}
