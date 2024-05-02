import 'package:e_kantin/models/withdrawals.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/utils/idr_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SellerWithdrawalItem extends StatelessWidget {
  final Withdrawal withdrawal;
  const SellerWithdrawalItem({
    super.key,
    required this.withdrawal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: getProportionateScreenHeight(16),
      ),
      child: GestureDetector(
        onTap: () => {},
        child: Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight * 0.12,
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(16),
            vertical: getProportionateScreenHeight(18),
          ),
          decoration: BoxDecoration(
            color: Colors.white70,
            border: Border.all(color: Colors.black12),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.5,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Withdrawal Store Funds",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: getProportionateScreenWidth(80),
                    padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(4),
                    ),
                    decoration: BoxDecoration(
                      color: withdrawal.status == 0
                          ? Colors.orange
                          : withdrawal.status == 1
                              ? Colors.green
                              : Colors.red,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        withdrawal.status == 0
                            ? "Pending"
                            : withdrawal.status == 1
                                ? "Accepted"
                                : "Declined",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: getProportionateScreenHeight(12),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatCurrency(withdrawal.amount),
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(14),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  Text(
                    DateFormat('HH.mm  -  dd MMM yyy').format(
                      withdrawal.date.toDate(),
                    ),
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
