import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:e_kantin/viewmodel/admin_viewmodel.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<AdminViewModel>(
      create: (_) => AdminViewModel(),
      builder: (context, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Profile'),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Admin",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text("admin@gmail.com"),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(20),
                    ),
                    width: double.infinity,
                    height: SizeConfig.screenHeight * 0.08,
                    decoration: const BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(color: Colors.black12),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        await AuthViewModel().signOut(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.logout,
                            color: Colors.red.shade700,
                          ),
                          SizedBox(
                            width: getProportionateScreenWidth(10),
                          ),
                          Text(
                            "Log Out",
                            style: TextStyle(color: Colors.red.shade700),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
