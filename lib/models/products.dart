class Product {
  final String id;
  final String name;
  final int price;
  final String description;
  final String sellerId;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.sellerId,
    required this.imageUrl,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'],
      price: data['price'].toInt(),
      description: data['description'],
      sellerId: data['seller_id'],
      imageUrl: data['image_url'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'seller_id': sellerId,
      'image_url': imageUrl,
    };
  }
}
