import 'package:e_kantin/constant.dart';
import 'package:e_kantin/models/sellers.dart';
import 'package:e_kantin/models/withdrawals.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/utils/idr_formatter.dart';
import 'package:e_kantin/view/admin/withdrawal_detail.dart';
import 'package:e_kantin/viewmodel/seller_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WithdrawalItem extends StatelessWidget {
  final Withdrawal withdrawal;
  const WithdrawalItem({super.key, required this.withdrawal});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SellerViewModel>(context, listen: true);
    viewModel.fetchSellers();
    return Consumer<SellerViewModel>(
      builder: (context, sellerViewModel, child) {
        final Seller? seller =
            sellerViewModel.getSellerByUserId(withdrawal.userId);
        return Padding(
          padding: EdgeInsets.only(bottom: getProportionateScreenHeight(10)),
          child: GestureDetector(
            onTap: withdrawal.status == 0
                ? () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => WithdrawalDetail(
                          withdrawal: withdrawal,
                          seller: seller!,
                        ),
                      ),
                    )
                : () {},
            child: Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight * 0.1,
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenHeight(20),
                vertical: getProportionateScreenHeight(15),
              ),
              decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(color: Colors.black12),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        sellerViewModel.sellers[0].storeName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(8),
                          vertical: getProportionateScreenHeight(2),
                        ),
                        decoration: BoxDecoration(
                          color: withdrawal.status == 0
                              ? Colors.orange.shade300
                              : withdrawal.status == 1
                                  ? Colors.green.shade300
                                  : Colors.red.shade300,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Text(
                          withdrawal.status == 0
                              ? "Pending"
                              : withdrawal.status == 1
                                  ? "Approved"
                                  : "Declined",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    formatCurrency(withdrawal.amount),
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(14),
                      color: kMainColor,
                      fontWeight: FontWeight.bold,
                    ),
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
