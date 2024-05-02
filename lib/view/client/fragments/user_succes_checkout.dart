import 'package:e_kantin/constant.dart';
import 'package:e_kantin/view/client/fragments/user_history_screen.dart';
import 'package:e_kantin/view/client/fragments/user_homepage_screen.dart';
import 'package:e_kantin/view/client/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_kantin/size_config.dart';

class CheckoutSuccess extends StatelessWidget {
  const CheckoutSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: getProportionateScreenWidth(200),
              height: getProportionateScreenHeight(200),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/sucessChecked.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
            const Text(
              'Ordered successfully',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              'Processed food will be made immediately',
              style: TextStyle(
                color: Color(0xFF6D6D6D),
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 90,
                        height: 85.71,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(side: const BorderSide(color: kSuccesBackground, width: 2), borderRadius: BorderRadius.circular(26)),
                          color: kSuccesBackground,
                        ),
                        child: const Center(
                          child: Image(
                            image: AssetImage("assets/iconSuccess.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left)
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Order Received',
                                  style: TextStyle(
                                    color: kButtonColor,
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Wait for it',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xFF6D6D6D),
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 90,
                        height: 85.71,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.orangeAccent.withOpacity(0.5), width: 2), borderRadius: BorderRadius.circular(26)),
                          color: Colors.orangeAccent.withOpacity(0.2),
                        ),
                        child: const Center(
                          child: Image(
                            image: AssetImage("assets/iconBox.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  child: Flexible(
                                    child: Text(
                                      'Prepared by the seller',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: kButtonColor,
                                        fontSize: 15,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  child: Flexible(
                                    child: Text(
                                      'We start preparing your order',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color(0xFF6D6D6D),
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(40)), // Additional spacing
            Container(
              width: getProportionateScreenWidth(342),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              decoration: ShapeDecoration(
                color: const Color(0xFF193748),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => const UserHistoryScreen(
                        arrow: true,
                      ));
                },
                child: const Text(
                  'Return to history',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Container(
              width: getProportionateScreenWidth(342),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => const NavigationMenu(
                        initialIndex: 0,
                      ));
                },
                child: const Text(
                  'Back to homepage',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF05161B),
                    fontSize: 16,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
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
