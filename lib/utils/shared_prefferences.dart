import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService._privateConstructor();
  static final SharedPreferencesService _instance =
      SharedPreferencesService._privateConstructor();
  static SharedPreferencesService get instance => _instance;
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setLoggedIn(bool value) async {
    return await _prefs?.setBool('isLoggedIn', value) ?? false;
  }

  bool isLoggedIn() {
    return _prefs?.getBool('isLoggedIn') ?? false;
  }

  Future<bool> setUserID(String uid) async {
    return await _prefs?.setString('uid', uid) ?? false;
  }

  String? getUserID() {
    return _prefs?.getString('uid');
  }

  Future<bool> setSellerID(String sellerId) async {
    return await _prefs?.setString('seller_id', sellerId) ?? false;
  }

  String? getSellerID() {
    return _prefs?.getString('seller_id');
  }

  Future<bool> setUserRole(int role) async {
    return await _prefs?.setInt('role', role) ?? false;
  }

  int? getUserRole() {
    return _prefs?.getInt('role');
  }

  Future<bool> setUserCart(List<String> cart) async {
    return await _prefs?.setStringList('cart', cart) ?? false;
  }

  List<String>? getUserCart() {
    return _prefs?.getStringList('cart');
  }

  String? getCurrentStoreName() {
    return _prefs?.getString('storeName');
  }

  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
