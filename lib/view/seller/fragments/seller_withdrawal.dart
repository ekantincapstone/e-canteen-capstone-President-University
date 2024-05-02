import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_kantin/models/withdrawals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_kantin/models/bank_account.dart';
import 'package:e_kantin/models/sellers.dart';
import 'package:e_kantin/utils/idr_formatter.dart';
import 'package:e_kantin/view/components/rounded_button.dart';
import 'package:e_kantin/viewmodel/bank_account_viemodel.dart';
import 'package:e_kantin/viewmodel/seller_viewmodel.dart';
import 'package:e_kantin/viewmodel/withdrawal_viewmodel.dart';
import 'package:e_kantin/size_config.dart';

class SellerWithdrawal extends StatefulWidget {
  final Seller seller;
  const SellerWithdrawal({super.key, required this.seller});

  @override
  State<SellerWithdrawal> createState() => _SellerWithdrawalState();
}

class _SellerWithdrawalState extends State<SellerWithdrawal> {
  final TextEditingController withdrawalAmountController =
      TextEditingController();
  BankAccount? selectedAccount;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAsync();
    });
  }

  void initAsync() async {
    // Fetch the initial seller data
    await Provider.of<SellerViewModel>(context, listen: false)
        .fetchSellerByUserId(widget.seller.userId);
    // ignore: use_build_context_synchronously
    await Provider.of<BankAccountViewModel>(context, listen: false)
        .fetchBankAccountsBySellerId(widget.seller.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Withdrawal'),
        centerTitle: true,
      ),
      body:
          Consumer3<BankAccountViewModel, WithdrawalViewModel, SellerViewModel>(
        builder: (context, bvm, wvm, svm, child) {
          if (svm.currentSeller == null && bvm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (bvm.accounts.isEmpty) {
            return const Center(
              child: Text(
                  'No accounts available.\n Please add your Bank Accounts in profile page.'),
            );
          }

          return buildBody(bvm.accounts, context, wvm, svm);
        },
      ),
    );
  }

  Widget buildBody(List<BankAccount> bankAccounts, BuildContext context,
      WithdrawalViewModel wvm, SellerViewModel svm) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenHeight(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildBankAccountsDropdown(bankAccounts),
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          buildWithdrawalInformation(svm),
          SizedBox(height: SizeConfig.screenHeight * 0.02),
          buildWithdrawalButton(context, wvm, svm),
        ],
      ),
    );
  }

  Widget buildWithdrawalInformation(svm) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Withdrawal Information",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: SizeConfig.screenHeight * 0.02),
            TextFormField(
              controller: withdrawalAmountController,
              decoration: InputDecoration(
                labelText: svm.currentSeller.balance < 100000
                    ? 'Min Withdrawal Rp. 100.000'
                    : 'Withdrawal Amount',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              enabled: svm.currentSeller.balance >= 100000,
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Available Balance:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(formatCurrency(svm.currentSeller.balance),
                    style: TextStyle(color: Colors.green.shade700)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWithdrawalButton(
      BuildContext context, WithdrawalViewModel wvm, SellerViewModel svm) {
    return svm.currentSeller!.balance < 100000
        ? const SizedBox()
        : RoundedButton(
            width: SizeConfig.screenWidth * 0.9,
            text: "Request Withdrawal",
            press: () async {
              int amount = int.tryParse(withdrawalAmountController.text) ?? 0;
              if (amount > 0 && selectedAccount != null) {
                var success = await attemptWithdrawal(amount, wvm, svm);
                if (success) {
                  showSuccessDialog(context);
                } else {
                  showErrorDialog(context);
                }
              }
            },
          );
  }

  Widget buildBankAccountsDropdown(List<BankAccount> bankAccounts) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      child: DropdownButtonFormField<BankAccount>(
        value: selectedAccount,
        decoration: const InputDecoration(
            labelText: 'Select Account', border: OutlineInputBorder()),
        items: bankAccounts
            .map((account) => DropdownMenuItem<BankAccount>(
                  value: account,
                  child: Text("${account.accountNumber} - ${account.bank}"),
                ))
            .toList(),
        onChanged: (BankAccount? newAccount) {
          setState(() {
            selectedAccount = newAccount;
          });
        },
      ),
    );
  }

  Future<bool> attemptWithdrawal(
      int amount, WithdrawalViewModel wvm, SellerViewModel svm) async {
    try {
      await wvm.addWithdrawal(
        Withdrawal.fromMap({
          'amount': amount,
          'date': Timestamp.now(),
          'seller_id': widget.seller.id,
          'account_id': selectedAccount?.id ?? '',
          'status': 0,
          'user_id': widget.seller.userId,
        }, ''),
      );
      await svm.updateSellerBalance(widget.seller.id, -amount);
      return true;
    } catch (e) {
      return false;
    }
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Withdrawal request successful!'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content:
            const Text('Failed to process withdrawal. Please try again later.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );
  }
}
