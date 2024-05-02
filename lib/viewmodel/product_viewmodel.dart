import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:e_kantin/models/products.dart';

class ProductViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Product> _products = [];

  List<Product> get products => _products;

  List<Product> _allProducts = [];

  List<Product> get allProducts => _allProducts;

  List<Product> get limitedProducts => List.from(_allProducts.take(6));

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    var snapshot = await _firestore.collection('products').get();
    _allProducts = snapshot.docs
        .map((doc) => Product.fromMap(doc.data(), doc.id))
        .toList();
    notifyListeners();
  }

  Future<void> fetchProductsBySellerId(String sellerId) async {
    try {
      setLoading(true);
      var querySnapshot = await _firestore
          .collection('products')
          .where('seller_id', isEqualTo: sellerId)
          .get();

      _products = querySnapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
      setLoading(false);
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching products: $e");
    }
  }

  Future<String> uploadImage(image) async {
    String fileName =
        'products/${DateTime.now().millisecondsSinceEpoch}_${image!.path.split('/').last}';
    Reference storageRef = FirebaseStorage.instance.ref(fileName);
    await storageRef.putFile(image!);
    return storageRef.getDownloadURL();
  }

  Future<void> saveProductInfo(String imageUrl, String productName,
      int productPrice, String productDescription, String sellerId) async {
    DocumentReference docRef = await _firestore.collection('products').add({
      'name': productName,
      'price': productPrice,
      'description': productDescription,
      'image_url': imageUrl,
      'seller_id': sellerId,
    });
    var product = Product(
        id: docRef.id,
        name: productName,
        price: productPrice,
        description: productDescription,
        imageUrl: imageUrl,
        sellerId: sellerId);
    _products.add(product);
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .update(product.toMap());
    int index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
    _products.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  String? getProductNameById(String productId) {
    final Product product = _allProducts.firstWhere((p) => p.id == productId);
    return product.name;
  }

  void setLoading(bool load) {
    _isLoading = load;
    notifyListeners();
  }
}
