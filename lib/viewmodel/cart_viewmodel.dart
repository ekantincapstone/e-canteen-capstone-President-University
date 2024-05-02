import 'package:e_kantin/models/products.dart';
import 'package:flutter/material.dart';
import 'package:e_kantin/models/cart_product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartModel with ChangeNotifier {
  String? currentSellerId;
  String? currentStoreName;

  List<CartProduct> _items = [];

  List<CartProduct> get items => _items;

  int get totalCount => _items.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice => _items.fold(
        0,
        (total, current) => total + current.quantity * current.product.price,
      );

  Future<void> loadCartItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var storedItems = prefs.getString('cartItems');
    if (storedItems != null) {
      Iterable decoded = json.decode(storedItems);
      _items = decoded.map((item) => CartProduct.fromJson(item)).toList();
    }
    currentSellerId = _items.isNotEmpty ? _items.first.product.sellerId : null;
    currentStoreName = prefs.getString('storeName');
    notifyListeners();
  }

  Future<void> addToCart(Product product, String storeName,
      {int quantity = 1}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (currentSellerId != null && currentSellerId != product.sellerId) {
      await clearCart();
    }

    currentSellerId = product.sellerId;
    prefs.setString('storeName', storeName);
    currentStoreName = storeName;

    int index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartProduct(product: product, quantity: quantity));
    }
    await _saveCartToPrefs();
    notifyListeners();
  }

  void updateItemQuantity(String productId, int quantity) async {
    int index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (quantity > 0) {
        _items[index].quantity = quantity;
      } else {
        _items.removeAt(index);
      }
      await _saveCartToPrefs();
      notifyListeners();
    }
  }

  void removeItem(String productId) async {
    int index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items.removeAt(index);
      await _saveCartToPrefs();
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _items.clear();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('storeName', '');
    currentStoreName = null;
    currentSellerId = null;
    await _saveCartToPrefs();
    notifyListeners();
  }

  Future<void> _saveCartToPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData =
        json.encode(_items.map((item) => item.toJson()).toList());
    await prefs.setString('cartItems', encodedData);
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }
}
