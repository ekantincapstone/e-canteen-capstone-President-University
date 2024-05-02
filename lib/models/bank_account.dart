class BankAccount {
  String id;
  String sellerId;
  String userId;
  String name;
  String bank;
  int accountNumber;

  BankAccount({
    required this.id,
    required this.userId,
    required this.sellerId,
    required this.name,
    required this.bank,
    required this.accountNumber,
  });

  factory BankAccount.fromMap(Map<String, dynamic> map, String id) {
    return BankAccount(
      id: id,
      sellerId: map['seller_id'],
      userId: map['user_id'],
      name: map['name'],
      bank: map['bank'],
      accountNumber: map['account_number'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'seller_id': sellerId,
      'user_id': userId,
      'name': name,
      'bank': bank,
      'account_number': accountNumber,
    };
  }
}
