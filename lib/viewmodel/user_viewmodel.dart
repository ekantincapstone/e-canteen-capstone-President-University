import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_kantin/utils/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:e_kantin/models/users.dart';
import 'package:cloud_functions/cloud_functions.dart';

class UsersViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions functions = FirebaseFunctions.instance;

  List<User> _users = [];

  List<User> get users => _users;

  Future<void> fetchUsers() async {
    var snapshot = await _firestore.collection('users').get();
    _users =
        snapshot.docs.map((doc) => User.fromMap(doc.data(), doc.id)).toList();
    notifyListeners();
  }

  void addUser(User user) async {
    await _firestore.collection('users').add(user.toMap());
    fetchUsers();
  }

  void updateUser(User user) async {
    await _firestore.collection('users').doc(user.docId).update(user.toMap());
    fetchUsers();
  }

  Future<dynamic> deleteUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.docId).delete();
      final result = await functions.httpsCallable('deleteUser').call({
        'uid': user.userId,
      });
      await fetchUsers();
      //print("User deleted successfully: $result");
      return result;
    } catch (e) {
      //print("Error deleting user: $e");
      return null;
    }
  }

  User? getUserById(String userId) {
    return _users.firstWhereOrNull((user) => user.userId == userId);
  }
}
