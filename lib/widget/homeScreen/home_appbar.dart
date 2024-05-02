import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/utils/shared_prefferences.dart';
import 'package:e_kantin/view/client/fragments/user_cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_kantin/constant.dart';
import 'package:e_kantin/widget/appbar/appbar.dart';
import 'package:e_kantin/widget/icon/cart_menu_icon.dart';
import 'package:provider/provider.dart';
import 'package:e_kantin/viewmodel/user_viewmodel.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final prefs = SharedPreferencesService.instance;
    return Consumer<UsersViewModel>(
      builder: (context, uvm, child) {
        final user = uvm.getUserById(prefs.getUserID() ?? '');

        return user != null
            ? CustomAppBar(
                iconColor: kSecondaryColor,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good day for some meals!',
                      style: GoogleFonts.poppins(
                        fontSize: getProportionateScreenHeight(14),
                        color: kSecondaryColor.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      user.name,
                      style: GoogleFonts.poppins(
                        fontSize: getProportionateScreenHeight(18),
                        fontWeight: FontWeight.bold,
                        color: kSecondaryColor,
                      ),
                    ),
                  ],
                ),
                actions: [
                  CartCounterIcon(
                    onPressed: () => Get.to(() => const CartScreen()),
                    iconColor: kSecondaryColor,
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
