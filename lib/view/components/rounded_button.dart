import 'package:e_kantin/constant.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final void Function() press;
  final Color color, textColor;
  final double width;
  final double border;
  final double margin;
  final double fontSize;
  final double vPadding;
  final double hPadding;
  const RoundedButton({
    super.key,
    required this.text,
    required this.press,
    this.color = kButtonColor,
    this.textColor = Colors.white,
    required this.width,
    this.border = 40,
    this.margin = 20,
    this.fontSize = 16,
    this.vPadding = 20,
    this.hPadding = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: margin),
      width: width,
      child: ClipRRect(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(border),
            ),
            elevation: 0,
            padding: EdgeInsets.symmetric(
              vertical: vPadding,
              horizontal: hPadding,
            ),
            backgroundColor: color,
          ),
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
