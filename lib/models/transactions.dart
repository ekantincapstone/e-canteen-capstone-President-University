class Transaction {
  String id;
  String userId;
  String address;
  String paymentLink;
  int amount;
  String status;

  Transaction({
    required this.id,
    required this.userId,
    required this.address,
    required this.paymentLink,
    required this.amount,
    required this.status,
  });

  factory Transaction.fromMap(Map<String, dynamic> data, String documentId) {
    return Transaction(
      id: documentId,
      userId: data['user_id'],
      address: data['address'],
      paymentLink: (data['payment_link']),
      amount: data['amount'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'address': address,
      'payment_link': paymentLink,
      'amount': amount,
      'status': status,
    };
  }
}
