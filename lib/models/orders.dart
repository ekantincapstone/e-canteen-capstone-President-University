import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String id;
  String userId;
  String sellerId;
  List<dynamic> products;
  int amount;
  Timestamp createdAt;
  int status;
  String proofPayment;

  Order({
    required this.id,
    required this.userId,
    required this.sellerId,
    required this.products,
    required this.amount,
    required this.createdAt,
    required this.status,
    required this.proofPayment,
  });

  factory Order.fromMap(Map<String, dynamic> data, String documentId) {
    return Order(
      id: documentId,
      userId: data['buyer_id'],
      sellerId: data['seller_id'],
      products: data['products'],
      amount: data['amount'],
      createdAt: data['created_at'],
      status: data['status'],
      proofPayment: data['payment_proof'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buyer_id': userId,
      'seller_id': sellerId,
      'products': products,
      'amount': amount,
      'created_at': createdAt,
      'status': status,
      'payment_proof': proofPayment,
    };
  }
}
