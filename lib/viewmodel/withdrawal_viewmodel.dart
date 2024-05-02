import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_kantin/models/withdrawals.dart';

class WithdrawalViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Withdrawal> _withdrawals = [];

  List<Withdrawal> get withdrawals => _withdrawals;

  Future<void> fetchAllWithdrawals() async {
    var snapshot = await _firestore
        .collection('withdrawals')
        .orderBy('date', descending: true)
        .get();
    _withdrawals = snapshot.docs
        .map((doc) => Withdrawal.fromMap(doc.data(), doc.id))
        .toList();
    notifyListeners();
  }

  Future<void> fetchWithdrawalsBysellerId(String sellerId) async {
    var snapshot = await _firestore
        .collection('withdrawals')
        .where('seller_id', isEqualTo: sellerId)
        .orderBy('date', descending: true)
        .get();
    _withdrawals = snapshot.docs
        .map((doc) => Withdrawal.fromMap(doc.data(), doc.id))
        .toList();
    notifyListeners();
  }

  Future<void> updateWithdrawalStatus(String id, int status) async {
    FirebaseFirestore.instance
        .collection('withdrawals')
        .doc(id)
        .update({'status': status});
    await fetchAllWithdrawals();
    notifyListeners();
  }

  Future<void> addWithdrawal(Withdrawal withdrawal) async {
    await _firestore.collection('withdrawals').add(withdrawal.toMap());
    fetchWithdrawalsBysellerId(withdrawal.sellerId);
  }

  Future<void> deleteWithdrawal(String id, String sellerId) async {
    await _firestore.collection('withdrawals').doc(id).delete();
    fetchWithdrawalsBysellerId(sellerId);
  }
}
