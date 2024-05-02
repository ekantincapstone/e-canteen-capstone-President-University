import 'package:e_kantin/models/products.dart';

class CartProduct {
  final Product product;
  int quantity;

  CartProduct({required this.product, this.quantity = 1});

  Map<String, dynamic> toJson() {
    return {
      'product': product.id,
      'quantity': quantity,
    };
  }

  static CartProduct fromJson(
    Map<String, dynamic> json,
  ) {
    final productId = json['product'].id;
    return CartProduct(
      product: Product.fromMap(json['product'], productId),
      quantity: json['quantity'],
    );
  }
}
