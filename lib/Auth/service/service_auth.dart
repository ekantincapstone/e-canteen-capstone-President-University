import 'package:e_kantin/utils/shared_prefferences.dart';
import 'package:e_kantin/widget/custom_shapes/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SharedPreferencesService _prefs = SharedPreferencesService.instance;

  Future<User?> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
    String phoneNum,
    String nim,
  ) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final user = {
          'user_id': credential.user!.uid,
          'name': name,
          'email': email,
          'phone': phoneNum,
          'nim': nim,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'role': 0,
        };

        DocumentReference docRef =
            await _firestore.collection("users").add(user);

        if (kDebugMode) {
          print('DocumentSnapshot added with ID: ${docRef.id}');
        }
        return credential.user;
      } else {
        if (kDebugMode) {
          print("User credential is null");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("error: $e");
      }
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    final loadingDialog = LoadingDialog(context);

    loadingDialog.show("Logging into an account");

    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      loadingDialog.hide();

      if (credential.user != null) {
        loadingDialog.hide();
        // ignore: avoid_print
        print('User signed in: ${credential.user!.email}');

        return credential.user;
      } else {
        loadingDialog.hide();
        // ignore: avoid_print
        print('usernya gaada');
        return null;
      }
    } catch (e) {
      loadingDialog.hide();
      if (kDebugMode) {
        print("error: $e");
      }
      return null;
    }
  }

  Future<bool> isUserRegistered(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking user registration: $e');
      }
      return false;
    }
  }

  Future<int?> getUserRole(String userId) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('user_id', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final QueryDocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        final role = documentSnapshot.get('role') as int?;
        return role;
      } else {
        // ignore: avoid_print
        print('User document not found for userId: $userId');
        return null;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error getting user role for userId $userId: $e');
      return null;
    }
  }

  Future<Map<String, String>> signOut(BuildContext context) async {
    try {
      await _auth.signOut(); // Sign out dari Firebase
      await _prefs.clearAll(); // Bersihkan preferensi
      return {
        "status": "LoginSuccess",
        "message": "Log Out Success", // Pesan sukses
      };
      // Pindah ke halaman login
    } catch (e) {
      // Jika terjadi kesalahan, kembalikan status error
      return {
        "status": "Error",
        "message": "Log Out Error: ${e.toString()}", // Pesan kesalahan
      };
    }
  }
}
