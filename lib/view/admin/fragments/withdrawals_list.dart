import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/admin/components/withdrawal_list_item.dart';
import 'package:e_kantin/viewmodel/withdrawal_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WithdrawalList extends StatelessWidget {
  const WithdrawalList({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WithdrawalViewModel>(context, listen: false);

    viewModel.fetchAllWithdrawals();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: getProportionateScreenHeight(80),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Withdrawals List",
        ),
      ),
      body: Consumer<WithdrawalViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: EdgeInsets.all(getProportionateScreenHeight(20)),
            child: SingleChildScrollView(
              child: Column(
                children: viewModel.withdrawals
                    .map((wd) => WithdrawalItem(withdrawal: wd))
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
