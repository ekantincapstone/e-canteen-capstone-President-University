import 'package:e_kantin/models/sellers.dart';
import 'package:e_kantin/models/withdrawals.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/seller/components/withdrawal_item.dart';
import 'package:e_kantin/viewmodel/withdrawal_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellerWithdrawalHistory extends StatefulWidget {
  final Seller seller;
  const SellerWithdrawalHistory({super.key, required this.seller});

  @override
  State<SellerWithdrawalHistory> createState() =>
      _SellerWithdrawalHistoryState();
}

class _SellerWithdrawalHistoryState extends State<SellerWithdrawalHistory> {
  late Future<List<Withdrawal>> withdrawalsFuture;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isLoaded) {
      withdrawalsFuture = fetchWithdrawals();
      isLoaded = true;
    }
  }

  Future<List<Withdrawal>> fetchWithdrawals() async {
    final wvm = Provider.of<WithdrawalViewModel>(context, listen: true);
    await wvm.fetchWithdrawalsBysellerId(widget.seller.id);
    return wvm.withdrawals;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Withdrawal>>(
      future: withdrawalsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Withdrawal> withdrawals = snapshot.data!;
          return body(withdrawals);
        } else {
          return const Center(
            child: Text(
              'No Withdrawal History',
            ),
          );
        }
      },
    );
  }

  Widget body(List<Withdrawal> withdrawals) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(16),
        horizontal: getProportionateScreenHeight(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: withdrawals
              .map(
                (withdrawal) => SellerWithdrawalItem(withdrawal: withdrawal),
              )
              .toList(),
        ),
      ),
    );
  }
}
