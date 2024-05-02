import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_kantin/models/bank_account.dart';

class BankAccountViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<BankAccount> _accounts = [];

  List<BankAccount> get accounts => _accounts;

  BankAccount? currentAccount;

  Future<void> fetchBankAccountById(String docId) async {
    var doc = await _firestore.collection('bankAccounts').doc(docId).get();
    if (doc.exists) {
      currentAccount =
          BankAccount.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      notifyListeners();
    } else {
      // ignore: avoid_print
      print("Seller not found");
    }
  }

  Future<List<BankAccount>> fetchBankAccountsBySellerId(String sellerId) async {
    setLoading(true);
    try {
      var snapshot = await _firestore
          .collection('bankAccounts')
          .where('seller_id', isEqualTo: sellerId)
          .get();

      _accounts = snapshot.docs
          .map((doc) => BankAccount.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners();

      setLoading(false);

      return _accounts;
    } catch (e) {
      setLoading(false);
      rethrow;
    }
  }

  Future<void> addBankAccount(BankAccount account) async {
    await _firestore.collection('bankAccounts').add(account.toMap());
    fetchBankAccountsBySellerId(account.sellerId);
  }

  Future<void> updateBankAccount(BankAccount account) async {
    await _firestore
        .collection('bankAccounts')
        .doc(account.id)
        .update(account.toMap());
    fetchBankAccountsBySellerId(account.sellerId);
  }

  Future<void> deleteBankAccount(String id, String sellerId) async {
    await _firestore.collection('bankAccounts').doc(id).delete();
    fetchBankAccountsBySellerId(sellerId);
  }
}
