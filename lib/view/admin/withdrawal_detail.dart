import 'package:e_kantin/models/sellers.dart';
import 'package:e_kantin/models/withdrawals.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/utils/idr_formatter.dart';
import 'package:e_kantin/view/components/rounded_button.dart';
import 'package:e_kantin/viewmodel/bank_account_viemodel.dart';
import 'package:e_kantin/viewmodel/withdrawal_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WithdrawalDetail extends StatelessWidget {
  final Withdrawal withdrawal;
  final Seller seller;
  const WithdrawalDetail(
      {super.key, required this.withdrawal, required this.seller});

  @override
  Widget build(BuildContext context) {
    final wvm = WithdrawalViewModel();
    return Consumer<BankAccountViewModel>(
      builder: (context, bankAccountViewModel, child) {
        bankAccountViewModel.fetchBankAccountsBySellerId(seller.id);
        return Scaffold(
          appBar: AppBar(
            title: const Text("Withdrawal Detail"),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(30),
              horizontal: getProportionateScreenWidth(35),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Withdrawal ID",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: getProportionateScreenHeight(14),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(withdrawal.id),
                Container(
                  height: getProportionateScreenHeight(22),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black12),
                    ),
                  ),
                ),
                // user.role == 1
                //     ? Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             "Seller ID",
                //             style: TextStyle(
                //               color: Colors.black54,
                //               fontSize: getProportionateScreenHeight(14),
                //             ),
                //           ),
                //           SizedBox(
                //             height: getProportionateScreenHeight(10),
                //           ),
                //           Text(
                //             sellerViewModel.sellers[0].id,
                //           ),
                //           Container(
                //             height: getProportionateScreenHeight(22),
                //             width: double.infinity,
                //             decoration: const BoxDecoration(
                //               border: Border(
                //                 top: BorderSide(color: Colors.black12),
                //               ),
                //             ),
                //           ),
                //           Text(
                //             "Store Name",
                //             style: TextStyle(
                //               color: Colors.black54,
                //               fontSize: getProportionateScreenHeight(14),
                //             ),
                //           ),
                //           SizedBox(
                //             height: getProportionateScreenHeight(10),
                //           ),
                //           Text(
                //             sellerViewModel.sellers[0].storeName,
                //           ),
                //           Container(
                //             height: getProportionateScreenHeight(22),
                //             width: double.infinity,
                //             decoration: const BoxDecoration(
                //               border: Border(
                //                 top: BorderSide(color: Colors.black12),
                //               ),
                //             ),
                //           ),
                //         ],
                //       )
                //     : const SizedBox(),
                Text(
                  "Store Name",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: getProportionateScreenHeight(14),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  bankAccountViewModel.accounts.isEmpty ? "" : seller.storeName,
                ),
                Container(
                  height: getProportionateScreenHeight(22),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black12),
                    ),
                  ),
                ),
                Text(
                  "Name",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: getProportionateScreenHeight(14),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  bankAccountViewModel.accounts.isNotEmpty
                      ? bankAccountViewModel.accounts[0].name
                      : "",
                ),
                Container(
                  height: getProportionateScreenHeight(22),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black12),
                    ),
                  ),
                ),
                Text(
                  "Bank - Account Number",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: getProportionateScreenHeight(14),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  bankAccountViewModel.accounts.isNotEmpty
                      ? "${bankAccountViewModel.accounts[0].bank} - ${bankAccountViewModel.accounts[0].accountNumber}"
                      : "",
                ),
                Container(
                  height: getProportionateScreenHeight(22),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black12),
                    ),
                  ),
                ),
                Text(
                  "Amount",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: getProportionateScreenHeight(14),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  formatCurrency(withdrawal.amount),
                ),
                Container(
                  height: getProportionateScreenHeight(22),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundedButton(
                  text: "Accept",
                  press: () {
                    wvm.updateWithdrawalStatus(withdrawal.id, 1);
                  },
                  width: SizeConfig.screenWidth * 0.4,
                  border: 10,
                  margin: 10,
                  color: Colors.green.shade700,
                ),
                RoundedButton(
                  text: "Decline",
                  press: () {
                    wvm.updateWithdrawalStatus(withdrawal.id, 2);
                  },
                  width: SizeConfig.screenWidth * 0.4,
                  border: 10,
                  margin: 10,
                  color: Colors.red.shade700,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
