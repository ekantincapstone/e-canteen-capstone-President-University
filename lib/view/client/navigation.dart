import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_kantin/models/users.dart' as mu;
import 'package:e_kantin/utils/shared_prefferences.dart';
import 'package:e_kantin/view/client/fragments/user_menu.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:e_kantin/constant.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/client/fragments/user_history_screen.dart';
import 'package:e_kantin/view/client/fragments/user_homepage_screen.dart';
import 'package:e_kantin/view/client/fragments/user_profile_screen.dart';
import 'package:e_kantin/viewmodel/user_viewmodel.dart';

class NavigationMenu extends StatefulWidget {
  final int initialIndex;
  const NavigationMenu({super.key, required this.initialIndex});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.getToken().then((token) {
      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    try {
      await FirebaseFirestore.instance
          .collection("tokens")
          .doc(SharedPreferencesService.instance.getUserID() ?? '')
          .set({'token': token});
    } catch (e) {
      print('error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = SharedPreferencesService.instance;
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: getProportionateScreenHeight(80),
          elevation: 0,
          indicatorColor: kMainColor.withOpacity(0.5),
          indicatorShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Iconsax.menu_board), label: 'Menu'),
            NavigationDestination(
                icon: Icon(Iconsax.archive), label: 'History'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Consumer<UsersViewModel>(
        builder: (context, uvm, child) {
          uvm.fetchUsers();
          mu.User? user = uvm.getUserById(prefs.getUserID() ?? '');
          return user != null
              ? Obx(() =>
                  controller.getScreen(controller.selectedIndex.value, user))
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  Widget getScreen(int index, mu.User user) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const MenuPage();
      case 2:
        return const UserHistoryScreen();
      case 3:
        return const UserProfileScreen();
      default:
        return const HomeScreen();
    }
  }
}
