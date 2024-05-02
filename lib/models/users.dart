class User {
  final String docId;
  final String nim;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final int role;

  User({
    required this.docId,
    required this.nim,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nim': nim,
      'email': email,
      'user_id': userId,
      'phone': phone,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map, String documentId) {
    return User(
      docId: documentId,
      userId: map['user_id'],
      nim: map['nim'] ?? '',
      name: map['name'],
      phone: map['phone'].toString(),
      email: map['email'],
      role: map['role'],
    );
  }
}
