import 'package:e_kantin/Auth/service/service_auth.dart';
import 'package:e_kantin/firebase_options.dart';
import 'package:e_kantin/utils/dismiss_keyboard.dart';
import 'package:e_kantin/utils/shared_prefferences.dart';
import 'package:e_kantin/view/splash.view.dart';
import 'package:e_kantin/viewmodel/bank_account_viemodel.dart';
import 'package:e_kantin/viewmodel/cart_viewmodel.dart';
import 'package:e_kantin/viewmodel/order_viewmodel.dart';
import 'package:e_kantin/viewmodel/product_viewmodel.dart';
import 'package:e_kantin/viewmodel/seller_viewmodel.dart';
import 'package:e_kantin/viewmodel/transaction_viewmodel.dart';
import 'package:e_kantin/viewmodel/user_viewmodel.dart';
import 'package:e_kantin/viewmodel/withdrawal_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'api/FirebaseApiMessaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(FirebaseAuthService());
  await SharedPreferencesService.instance.init();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await FirebaseApiMessaging.initialize();
  String? token = await FirebaseApiMessaging.getToken(); // Get FCM token
  print('Firebase Messaging Token: $token');

  // Request permission for iOS
  // NotificationSettings settings = await messaging.requestPermission();
  // print('User granted permission: ${settings.authorizationStatus}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsersViewModel()),
        ChangeNotifierProvider(create: (_) => SellerViewModel()),
        ChangeNotifierProvider(create: (_) => BankAccountViewModel()),
        ChangeNotifierProvider(create: (_) => WithdrawalViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
        ChangeNotifierProvider(create: (_) => UserTransactionsViewModel()),
        ChangeNotifierProvider(create: (_) => CartModel()),
      ],
      child: const DismissKeyboard(
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashView(),
        ),
      ),
    );
  }
}
