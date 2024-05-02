import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:e_kantin/models/transactions.dart' as mt;

class UserTransactionsViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<mt.Transaction> _transactions = [];

  UserTransactionsViewModel();

  List<mt.Transaction> get transactions => _transactions;

  void fetchTransactions(String userId) async {
    var snapshot = await _firestore
        .collection('transactions')
        .where('user_id', isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();
    _transactions = snapshot.docs
        .map((doc) => mt.Transaction.fromMap(doc.data(), doc.id))
        .toList();
    notifyListeners();
  }
}

Future<String> createTransaction(mt.Transaction transaction) async {
  DocumentReference transactionRef = await FirebaseFirestore.instance
      .collection('transactions')
      .add(transaction.toMap());

  return transactionRef.id;
}
