import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_kantin/viewmodel/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:e_kantin/models/sellers.dart';

class SellerViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uvm = UsersViewModel();
  List<Seller> _sellers = [];

  List<Seller> get sellers => _sellers;

  Seller? currentSeller;

  Future<void> fetchSellers() async {
    var snapshot = await _firestore.collection('sellers').get();
    _sellers =
        snapshot.docs.map((doc) => Seller.fromMap(doc.data(), doc.id)).toList();
    notifyListeners();
  }

  Seller? getSellerByUserId(String userId) {
    try {
      return _sellers.firstWhere((seller) => seller.userId == userId);
    } catch (e) {
      return null;
    }
  }

  Seller? getSellerById(String sellerId) {
    try {
      return _sellers.firstWhere((seller) => seller.id == sellerId);
    } catch (e) {
      return null;
    }
  }

  Future<void> fetchSellerByUserId(String userId) async {
    try {
      var querySnapshot = await _firestore
          .collection('sellers')
          .where('user_id', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        currentSeller = Seller.fromMap(
            querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
        notifyListeners();
      } else {
        currentSeller = null;
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching seller by user ID: $e");
      currentSeller = null;
    }
  }

  Seller? getCurrentSeller() {
    return currentSeller;
  }

  void addSeller(Seller seller) async {
    // DocumentReference docRef =
    await _firestore.collection('sellers').add(seller.toMap());
    await uvm.fetchUsers();
    fetchSellers();
  }

  void updateSeller(Seller seller) async {
    await _firestore
        .collection('sellers')
        .doc(seller.id)
        .update(seller.toMap());
    fetchSellers();
  }

  Future<void> updateSellerBalance(String sellerId, int change) async {
    DocumentReference sellerRef =
        _firestore.collection('sellers').doc(sellerId);

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(sellerRef);

        if (!snapshot.exists) {
          throw Exception("Seller does not exist!");
        }

        int newBalance =
            (snapshot.data() as Map<String, dynamic>)['balance'] + change;
        transaction.update(sellerRef, {'balance': newBalance});
      });
      fetchSellers();
      // ignore: avoid_print
      print("Balance updated successfully.");
    } catch (e) {
      // ignore: avoid_print
      print("Error updating balance: $e");
      // ignore: use_rethrow_when_possible
      throw e; // Consider handling this error appropriately
    }
  }

  Future<void> updateSellerQR(String sellerId, String newQRUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(sellerId)
          .update({
        'qr_url': newQRUrl,
      });
      fetchSellers();
      // ignore: avoid_print
      print('QR URL updated successfully.');
    } catch (e) {
      // ignore: avoid_print
      print('Error updating QR URL: $e');
      throw Exception('Failed to update QR URL');
    }
  }

  void deleteSeller(String userId) async {
    await _firestore.collection('sellers').where('user_id', isEqualTo: userId);
    fetchSellers();
  }
}
