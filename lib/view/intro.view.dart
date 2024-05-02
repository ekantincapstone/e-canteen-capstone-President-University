import 'package:e_kantin/constant.dart';
import 'package:e_kantin/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_kantin/Auth/login_screen.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 390,
            height: 844,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Stack(
              children: [
                const Positioned(
                  left: -119,
                  top: -85,
                  child: SizedBox(
                    width: 565,
                    height: 444,
                    child: Stack(
                      children: [],
                    ),
                  ),
                ),
                Positioned(
                  left: -94,
                  top: 484,
                  child: Container(
                    width: 540,
                    height: 360,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/introPaper.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: -8,
                  child: Container(
                    width: 390,
                    height: 535,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/IntroBackground.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 213,
                  top: 229.11,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(0.0, 0.0)
                      ..rotateZ(-0.32),
                    child: const SizedBox(width: 95, height: 63),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 70,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: SizeConfig.screenHeight * 0.08,
                            height: SizeConfig.screenHeight * 0.08,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/logo.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(32)),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.76,
                                child: Text(
                                  'Get your food delivered to your class',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: kButtonColor,
                                      fontSize:
                                          getProportionateScreenHeight(28),
                                      fontFamily: 'DM Sans',
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.none),
                                ),
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(24)),
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.7,
                                child: Text(
                                  'The best delivery app in uni for delivering your daily food',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 115, 115, 115),
                                      fontSize:
                                          getProportionateScreenHeight(16),
                                      fontFamily: 'DM Sans',
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: getProportionateScreenHeight(40)),
                      Card(
                        color: kButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 4,
                        child: InkWell(
                          onTap: () {
                            Get.to(() => const LoginScreen());
                          },
                          child: Container(
                            width: getProportionateScreenWidth(190),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Shop now',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: getProportionateScreenHeight(16),
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
