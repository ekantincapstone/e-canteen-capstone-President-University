import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_kantin/Auth/service/service_auth.dart';
import 'package:e_kantin/viewmodel/seller_viewmodel.dart';
import 'package:e_kantin/viewmodel/user_viewmodel.dart';
import 'package:e_kantin/models/users.dart' as mu;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_kantin/models/sellers.dart';

class AdminViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uvm = UsersViewModel();

  Future<Map<String, String>> signUpSeller(
      String name, String password, Seller sellerInfo) async {
    try {
      User? user = await FirebaseAuthService().signUpWithEmailAndPassword(
          name, sellerInfo.email, password, sellerInfo.phone, '');
      String userId = user!.uid;

      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('user_id', isEqualTo: userId)
          .get();

      for (var doc in querySnapshot.docs) {
        DocumentReference docRef = doc.reference;

        await docRef.update(
          {'role': 1},
        ).catchError((error) => print("Failed to update document: $error"));
      }

      sellerInfo.userId = userId;

      await addSellerInfo(sellerInfo);

      return {
        'status': 'Success',
        'message': 'Seller Account Created!',
      };
    } catch (e) {
      return {
        'status': 'Error',
        'message': 'Failed to create user and seller info: $e',
      };
    }
  }

  Future<void> addSellerInfo(Seller seller) async {
    await _firestore.collection('sellers').add(seller.toMap());
    notifyListeners();
  }

  Future<void> updateSellerInfo(Seller updatedSeller) async {
    await _firestore
        .collection('sellers')
        .doc(updatedSeller.id)
        .update(updatedSeller.toMap());
    notifyListeners();
  }

  Future<Map<String, String>> adminDeleteUser(
      mu.User user, SellerViewModel sellerViewModel) async {
    try {
      var result = await uvm.deleteUser(user);
      if (user.role == 1) {
        sellerViewModel.deleteSeller(user.docId);
      }
      notifyListeners();

      return result != null
          ? {
              "status": "Success",
              "message": "$result",
            }
          : {
              "status": "Error",
              "message": "Delete user failed!",
            };
    } catch (e) {
      //print("Error Delete User: $e");
      return {
        "status": "Error",
        "message": "$e",
      };
    }
  }
}
