import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/components/rounded_button.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final Future<dynamic> func;
  final String title;
  final String message;
  final Color buttonColor;

  const CustomDialog({
    super.key,
    required this.func,
    required this.title,
    required this.message,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenWidth(16),
          horizontal: getProportionateScreenHeight(32),
        ),
        decoration: const BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: getProportionateScreenHeight(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.02),
            Text(message),
            SizedBox(height: SizeConfig.screenHeight * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RoundedButton(
                  text: "No",
                  press: () {
                    Navigator.of(context).pop();
                  },
                  width: SizeConfig.screenWidth * 0.26,
                  border: 10,
                  color: Colors.black12,
                  textColor: Colors.black87,
                  vPadding: 10,
                  hPadding: 10,
                ),
                RoundedButton(
                  text: "Yes",
                  press: () {
                    func;
                  },
                  width: SizeConfig.screenWidth * 0.26,
                  border: 10,
                  color: buttonColor,
                  textColor: Colors.white,
                  vPadding: 10,
                  hPadding: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
