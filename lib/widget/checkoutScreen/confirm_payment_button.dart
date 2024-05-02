import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/components/rounded_button.dart';
import 'package:flutter/material.dart';

class ConfirmPaymentButton extends StatelessWidget {
  final bool isProofUploaded;
  final void Function() onConfirm;

  const ConfirmPaymentButton({
    super.key,
    required this.isProofUploaded,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      text: 'Confirm Payment',
      press: isProofUploaded ? onConfirm : () {},
      width: SizeConfig.screenWidth * 0.5,
      margin: 0,
      border: 10,
      hPadding: 12,
    );
  }
}
