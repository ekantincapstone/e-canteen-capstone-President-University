import 'package:e_kantin/models/users.dart' as mu;
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/components/custom_dialog.dart';
import 'package:e_kantin/view/components/rounded_button.dart';
import 'package:e_kantin/viewmodel/admin_viewmodel.dart';
import 'package:e_kantin/viewmodel/seller_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetail extends StatelessWidget {
  final mu.User user;
  const UserDetail({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final avm = AdminViewModel();
    return Consumer<SellerViewModel>(
      builder: (context, sellerViewModel, child) {
        if (user.role == 1) {
          sellerViewModel.fetchSellerByUserId(user.userId);
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("${user.role == 0 ? "User" : "Seller"} Detail"),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(30),
              horizontal: getProportionateScreenWidth(35),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "User ID",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: getProportionateScreenHeight(14),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Text(user.userId),
                  Container(
                    height: getProportionateScreenHeight(22),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.black12),
                      ),
                    ),
                  ),
                  user.role == 1
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Seller ID",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: getProportionateScreenHeight(14),
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Text(
                              sellerViewModel.sellers[0].id,
                            ),
                            Container(
                              height: getProportionateScreenHeight(22),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.black12),
                                ),
                              ),
                            ),
                            Text(
                              "Store Name",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: getProportionateScreenHeight(14),
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Text(
                              sellerViewModel.sellers[0].storeName,
                            ),
                            Container(
                              height: getProportionateScreenHeight(22),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.black12),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  Text(
                    "Name",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: getProportionateScreenHeight(14),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Text(
                    user.name,
                  ),
                  Container(
                    height: getProportionateScreenHeight(22),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.black12),
                      ),
                    ),
                  ),
                  user.role == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "NIM",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: getProportionateScreenHeight(14),
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Text(
                              user.nim,
                            ),
                            Container(
                              height: getProportionateScreenHeight(22),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.black12),
                                ),
                              ),
                            )
                          ],
                        )
                      : const SizedBox(),
                  Text(
                    "Email",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: getProportionateScreenHeight(14),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Text(
                    user.email,
                  ),
                  Container(
                    height: getProportionateScreenHeight(22),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.black12),
                      ),
                    ),
                  ),
                  Text(
                    "Phone Number",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: getProportionateScreenHeight(14),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Text(
                    "0${user.phone}",
                  ),
                  Container(
                    height: getProportionateScreenHeight(22),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.black12),
                      ),
                    ),
                  ),
                  Text(
                    "User Type",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: getProportionateScreenHeight(14),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Text(
                    user.role == 0 ? "Student" : "Seller",
                  ),
                  Container(
                    height: getProportionateScreenHeight(22),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.black12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(30),
            ),
            child: RoundedButton(
              text: "Delete",
              press: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    buttonColor: Colors.red.shade700,
                    message: "Are you sure delete this User?",
                    title: "Delete User",
                    func: avm.adminDeleteUser(user, sellerViewModel).then(
                          (value) => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(value["status"] ?? ''),
                              content: Text(value["message"] ?? "Error"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ),
                );
              },
              width: SizeConfig.screenWidth * 0.9,
              border: 10,
              margin: 10,
              color: Colors.red.shade700,
            ),
          ),
        );
      },
    );
  }
}
