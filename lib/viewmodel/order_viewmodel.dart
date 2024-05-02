import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_kantin/models/orders.dart' as mo;

class OrderViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<mo.Order> _orders = [];

  List<mo.Order> get orders => _orders;

  List<mo.Order> _userOrders = [];

  List<mo.Order> get userOrders => _userOrders;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetchOrdersForSeller(String sellerId) async {
    try {
      var querySnapshot = await _firestore
          .collection('orders')
          .where('seller_id', isEqualTo: sellerId)
          .orderBy('created_at', descending: true)
          .get();

      _orders = querySnapshot.docs
          .map((doc) => mo.Order.fromMap(doc.data(), doc.id))
          .toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  Future<void> fetchOrdersForUser(String userId) async {
    setLoading(true);
    try {
      var querySnapshot = await _firestore
          .collection('orders')
          .where('buyer_id', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .get();

      _userOrders = querySnapshot.docs
          .map((doc) => mo.Order.fromMap(doc.data(), doc.id))
          .toList();

      notifyListeners();
      setLoading(false);
    } catch (e) {
      setLoading(false);
      print('Error fetching orders: $e');
    }
  }

  void setLoading(bool load) {
    _isLoading = load;
    notifyListeners();
  }

  Future<String> addOrder(mo.Order newOrder) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('orders').add(newOrder.toMap());
      newOrder.id = docRef.id;
      _orders.add(newOrder);
      notifyListeners();
      return docRef.id;
    } catch (e) {
      print('Error adding order: $e');
      rethrow;
    }
  }

  Future<void> updateOrderStatus(String orderId, int newStatus) async {
    try {
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({'status': newStatus});
      int index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index].status = newStatus;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating order status: $e');
    }
  }
}
