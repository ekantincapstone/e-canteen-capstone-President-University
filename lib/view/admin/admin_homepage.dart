import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/admin/fragments/add_seller.dart';
import 'package:e_kantin/view/admin/fragments/admin_profile.dart';
import 'package:e_kantin/view/admin/fragments/user_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavbarControllerAdmin());
    return Scaffold(
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: SizeConfig.screenHeight * 0.1,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (i) => controller.selectedIndex.value = i,
          destinations: const [
            NavigationDestination(
              icon: Icon(Iconsax.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.shop_add),
              label: 'Add Seller',
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
}

class NavbarControllerAdmin extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const UserList(),
    AddSellerPage(),
    const AdminProfile(),
  ];
}
