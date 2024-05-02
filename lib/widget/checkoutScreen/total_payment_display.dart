import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/utils/idr_formatter.dart';
import 'package:flutter/material.dart';

class TotalPaymentDisplay extends StatelessWidget {
  final int total;

  const TotalPaymentDisplay({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(16)),
      child: Text(
        'Total Payment: ${formatCurrency(total)}',
        style: TextStyle(
          fontSize: getProportionateScreenHeight(20),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
