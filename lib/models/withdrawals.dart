import 'package:cloud_firestore/cloud_firestore.dart';

class Withdrawal {
  final String id;
  final int amount;
  final Timestamp date;
  final String sellerId;
  final String userId;
  final int status;
  final String accountId;

  Withdrawal({
    required this.id,
    required this.amount,
    required this.date,
    required this.sellerId,
    required this.userId,
    required this.status,
    required this.accountId,
  });

  factory Withdrawal.fromMap(Map<String, dynamic> data, String id) {
    return Withdrawal(
      id: id,
      amount: data['amount'],
      date: data['date'],
      sellerId: data['seller_id'],
      accountId: data['account_id'],
      status: data['status'],
      userId: data['user_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': date,
      'seller_id': sellerId,
      'user_id': userId,
      'account_id': accountId,
      'status': status,
    };
  }
}
