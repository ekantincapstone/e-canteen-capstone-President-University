import 'package:e_kantin/viewmodel/seller_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:e_kantin/models/sellers.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/utils/idr_formatter.dart';
import 'package:e_kantin/view/seller/fragments/qr_payment.dart';
import 'package:e_kantin/viewmodel/auth_viewmodel.dart';
import 'package:e_kantin/widget/appbar/appbar.dart';

class SellerProfile extends StatefulWidget {
  final Seller seller;
  const SellerProfile({super.key, required this.seller});

  @override
  State<SellerProfile> createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        iconColor: Colors.black,
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: buildProfile(context),
    );
  }

  Widget buildProfile(BuildContext context) {
    return Consumer<SellerViewModel>(builder: (context, svm, child) {
      svm.fetchSellers();
      Seller? currentSeller = svm.getSellerById(widget.seller.id);
      return currentSeller != null
          ? SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenHeight(40),
                vertical: getProportionateScreenHeight(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    currentSeller.storeName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(formatCurrency(currentSeller.balance)),
                  const SizedBox(height: 20),
                  profileOption(Icons.qr_code_2_rounded, "My QR Code", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SellerQRPage(seller: widget.seller),
                      ),
                    );
                  }),
                  profileOption(Iconsax.logout, "Log Out", () async {
                    await AuthViewModel().signOut(context);
                  },
                      iconColor: Colors.red.shade700,
                      textColor: Colors.red.shade700),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            );
    });
  }

  Widget profileOption(IconData icon, String text, VoidCallback onTap,
      {Color? iconColor, Color? textColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: SizeConfig.screenHeight * 0.08,
        decoration: const BoxDecoration(
          border:
              Border.symmetric(horizontal: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? Colors.black),
            SizedBox(width: getProportionateScreenWidth(10)),
            Text(text, style: TextStyle(color: textColor ?? Colors.black)),
          ],
        ),
      ),
    );
  }
}
