import 'package:flutter/material.dart';

class ListBankAccounts extends StatelessWidget {
  const ListBankAccounts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Accounts"),
        centerTitle: true,
      ),
    );
  }
}
