class Seller {
  String id;
  String userId;
  final String email;
  final String phone;
  final String storeName;
  int balance;
  String qrUrl;

  Seller({
    required this.id,
    required this.userId,
    required this.email,
    required this.phone,
    required this.storeName,
    required this.balance,
    required this.qrUrl,
  });

  factory Seller.fromMap(Map<String, dynamic> data, String documentId) {
    return Seller(
      id: documentId,
      userId: data['user_id'],
      email: data['email'],
      phone: data['phone'],
      storeName: data['store_name'],
      balance: data['balance'],
      qrUrl: data['qr_url'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'email': email,
      'phone': phone,
      'store_name': storeName,
      'balance': balance,
      'qr_url': qrUrl,
    };
  }
}
