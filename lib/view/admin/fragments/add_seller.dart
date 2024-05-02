import 'package:e_kantin/models/sellers.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_kantin/viewmodel/admin_viewmodel.dart';

class AddSellerPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AddSellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<AdminViewModel>(
      create: (_) => AdminViewModel(),
      builder: (context, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Create Seller Account'),
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenHeight(40),
                vertical: getProportionateScreenHeight(20),
              ),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.02,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.02,
                  ),
                  TextField(
                    controller: storeNameController,
                    decoration: const InputDecoration(labelText: 'Store Name'),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.02,
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.02,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.04,
                  ),
                  // RoundedButton(
                  //   text: 'Add Seller',
                  //   press: () {
                  //     if (emailController.text.isNotEmpty &&
                  //         nameController.text.isNotEmpty &&
                  //         storeNameController.text.isNotEmpty &&
                  //         passwordController.text.isNotEmpty &&
                  //         phoneController.text.isNotEmpty) {
                  //       AdminViewModel().signUpSeller(
                  //         emailController.text,
                  //         passwordController.text,
                  //         Seller(
                  //             id: '',
                  //             email: emailController.text,
                  //             phone: phoneController.text,
                  //             storeName: storeNameController.text,
                  //             userId: ''),
                  //       );
                  //     } else {
                  //       // For Empty Form
                  //     }
                  //   },
                  //   width: SizeConfig.screenWidth * 0.5,
                  //   border: 20,
                  //   vPadding: getProportionateScreenHeight(22),
                  // ),
                  RoundedButton(
                    text: 'Add Seller',
                    press: () {
                      if (emailController.text.isNotEmpty &&
                          nameController.text.isNotEmpty &&
                          storeNameController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty &&
                          phoneController.text.isNotEmpty) {
                        AdminViewModel()
                            .signUpSeller(
                              nameController.text,
                              passwordController.text,
                              Seller(
                                id: '',
                                email: emailController.text,
                                phone: phoneController.text,
                                storeName: storeNameController.text,
                                userId: '',
                                balance: 0,
                                qrUrl: '',
                              ),
                            )
                            .then(
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
                            );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content: const Text("Please fill all the field!"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    width: SizeConfig.screenWidth * 0.8,
                    border: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
