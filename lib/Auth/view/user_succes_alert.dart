import 'package:e_kantin/constant.dart';
import 'package:e_kantin/view/client/navigation.dart';
import 'package:e_kantin/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class UserSuccesfullLogin extends StatelessWidget {
  const UserSuccesfullLogin({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(40),
          horizontal: getProportionateScreenWidth(25),
        ),
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: getProportionateScreenWidth(365),
              height: getProportionateScreenHeight(365),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/success_alert.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Text(
              'Login Success!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: getProportionateScreenWidth(32),
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        'Your login process has been successful, you can continue to \n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(15),
                      fontFamily: 'DM Sans',
                    ),
                  ),
                  TextSpan(
                    text: 'Halaman utama',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(15),
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NavigationMenu(
                              initialIndex: 0,
                            ),
                          ),
                        );
                      },
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NavigationMenu(
                      initialIndex: 0,
                    ),
                  ),
                );
              },
              child: Container(
                width: getProportionateScreenWidth(342),
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(8),
                  vertical: getProportionateScreenHeight(16),
                ),
                decoration: BoxDecoration(
                  color: kButtonColor,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: kButtonColor.withOpacity(0.3),
                      blurRadius: getProportionateScreenWidth(4),
                      offset: Offset(0, getProportionateScreenHeight(4)),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Go to Home Page',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: getProportionateScreenWidth(16),
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
