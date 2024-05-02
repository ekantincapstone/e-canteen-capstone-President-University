import 'package:e_kantin/models/sellers.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/utils/shared_prefferences.dart';
import 'package:e_kantin/view/seller/fragments/seller_activity.dart';
import 'package:e_kantin/view/seller/fragments/seller_profile.dart';
import 'package:e_kantin/view/seller/fragments/seller_store.dart';
import 'package:e_kantin/viewmodel/seller_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class SellerHomepage extends StatelessWidget {
  const SellerHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SellerViewModel>(
      builder: (context, svm, child) {
        svm.fetchSellerByUserId(
            SharedPreferencesService.instance.getUserID() ?? '');
        if (svm.currentSeller == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          final seller = svm.currentSeller!;
          final controller = Get.put(NavbarController(seller));
          return Scaffold(
            body: Obx(() => controller.screens[controller.selectedIndex.value]),
            bottomNavigationBar: Obx(
              () => NavigationBar(
                height: SizeConfig.screenHeight * 0.1,
                elevation: 0,
                selectedIndex: controller.selectedIndex.value,
                onDestinationSelected: (i) =>
                    controller.selectedIndex.value = i,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Iconsax.shop),
                    label: 'My Store',
                  ),
                  NavigationDestination(
                    icon: Icon(Iconsax.document_text),
                    label: 'Orders',
                  ),
                  NavigationDestination(
                    icon: Icon(Iconsax.user_octagon),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class NavbarController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final Seller seller;

  late final List<Widget> screens;

  NavbarController(this.seller) {
    screens = [
      ProductList(seller: seller),
      SellerActivity(seller: seller),
      SellerProfile(seller: seller),
    ];
  }
}
