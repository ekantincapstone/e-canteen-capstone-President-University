import 'package:e_kantin/utils/shared_prefferences.dart';
import 'package:e_kantin/view/client/fragments/user_cart_screen.dart';
import 'package:e_kantin/view/client/fragments/user_history_screen.dart';
import 'package:e_kantin/viewmodel/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:e_kantin/constant.dart';
import 'package:e_kantin/view/components/rounded_button.dart';
import 'package:e_kantin/viewmodel/auth_viewmodel.dart';
import 'package:e_kantin/widget/appbar/appbar.dart';
import 'package:e_kantin/widget/container/section_heading.dart';
import 'package:e_kantin/widget/container/setting_menu_tile.dart';
import 'package:e_kantin/widget/profileScreen/user_profile_tile.dart';
import 'package:e_kantin/widget/container/primary_header_container.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:e_kantin/size_config.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<UsersViewModel>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize SizeConfig for this context
    SizeConfig.init(context);

    return Scaffold(
      body: Consumer<UsersViewModel>(
        builder: (context, model, child) {
          final prefs = SharedPreferencesService.instance;
          final user = model.getUserById(prefs.getUserID() ?? '');
          return user == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      PrimaryHeaderContainer(
                        child: Column(
                          children: [
                            CustomAppBar(
                              iconColor: kSecondaryColor,
                              title: Text(
                                'Account',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .apply(color: kSecondaryColor),
                              ),
                            ),
                            UserProfileTile(
                              user: user,
                            ),
                            SizedBox(height: getProportionateScreenHeight(32)),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(getProportionateScreenWidth(24)),
                        child: Column(
                          children: [
                            const SectionHeading(
                              title: 'Account Setting',
                              showActionButton: false,
                            ),
                            SizedBox(height: getProportionateScreenHeight(20)),
                            SettingMenuTile(
                              icon: Iconsax.shopping_cart,
                              title: 'My Cart',
                              subTitle:
                                  'Add, remove products, and move to checkout',
                              onTap: () {
                                Get.to(() => const CartScreen());
                              },
                            ),
                            SettingMenuTile(
                              icon: Iconsax.bag_tick,
                              title: 'My Orders',
                              subTitle: 'Track, return, or buy again',
                              onTap: () {
                                Get.to(() => const UserHistoryScreen(
                                      arrow: true,
                                    ));
                              },
                            ),

                            // Log out button
                            SizedBox(height: getProportionateScreenHeight(20)),
                            RoundedButton(
                              text: 'Log out',
                              press: () async {
                                await AuthViewModel().signOut(context);
                              },
                              width: double.infinity,
                              color: kButtonColor,
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
