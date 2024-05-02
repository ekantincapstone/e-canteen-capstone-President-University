import 'package:e_kantin/Auth/login_screen.dart';
import 'package:e_kantin/Auth/service/service_auth.dart';
import 'package:e_kantin/Auth/view/admin_succes_alert.dart';
import 'package:e_kantin/Auth/view/user_succes_alert.dart';
import 'package:e_kantin/utils/shared_prefferences.dart';
import 'package:e_kantin/view/components/custom_dialog.dart';
import 'package:e_kantin/view/seller/seller_home.dart';
import 'package:e_kantin/widget/custom_shapes/loading_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthViewModel with ChangeNotifier {
  final _firebaseAuthService = FirebaseAuthService();
  final _prefs = SharedPreferencesService.instance;

  Future<void> signIn(
    GlobalKey<FormState> formKey,
    String email,
    String password,
    context,
  ) async {
    if (formKey.currentState!.validate()) {
      try {
        final result = await _firebaseAuthService.signInWithEmailAndPassword(
          email,
          password,
          context,
        );

        LoadingDialog(context).hide();

        if (result == null) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Login Failed'),
              content: const Text(
                'Email atau password yang Anda masukkan salah.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          final role = await _firebaseAuthService.getUserRole(result.uid);

          await _prefs.setLoggedIn(true);
          await _prefs.setUserID(
            result.uid,
          );
          if (role != null) {
            await _prefs.setUserRole(role);
          }

          if (role == 0) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserSuccesfullLogin(),
              ),
            );
          } else if (role == 1) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SellerHomepage(),
              ),
            );
          } else if (role == 2) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminSuccesfullLogin(),
              ),
            );
          } else {
            // ignore: avoid_print
            print('Unknown role: $role');
          }
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Error'),
            content: Text('Error: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> signUp(
    formKey,
    String name,
    String password,
    String email,
    String phoneNum,
    String nim,
    context,
  ) async {
    final loadingDialog = LoadingDialog(context);

    loadingDialog.show("Sedang daftar...");
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      try {
        final isUserRegistered =
            await _firebaseAuthService.isUserRegistered(email);

        if (isUserRegistered) {
          loadingDialog.hide();

          _showDialog(
            'Sign Up Failed',
            'User with this email address already exists.',
            context,
          );
        } else {
          final signUpResult = await _firebaseAuthService
              .signUpWithEmailAndPassword(name, email, password, phoneNum, nim);

          if (signUpResult != null) {
            loadingDialog.hide();

            _showDialog(
              'Sign Up Successful',
              'You have successfully signed up.',
              context,
            );
          } else {
            loadingDialog.hide();

            _showDialog(
              'Sign Up Failed',
              'Sign up failed. Please try again.',
              context,
            );
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error during sign-up: $e');
        }
        _showDialog(
          'Sign Up Failed',
          'An error occurred during sign up. Please try again.',
          context,
        );
      }
    } else {
      _showDialog(
        'Sign Up Failed',
        'Please fill in all fields.',
        context,
      );
    }
  }

  void _showDialog(String title, String message, context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    ).then((_) {
      if (title == 'Sign Up Successful') {
        Get.off(const LoginScreen());
      }
    });
  }

  Future<void> signOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        func: _firebaseAuthService.signOut(context).then(
          (value) {
            Navigator.of(context).pop();
            if (value["status"] == "LoginSuccess") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Error"),
                  content: Text(value["message"] ?? "Terjadi kesalahan"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            }
          },
        ),
        title: 'Konfirmasi Logout',
        message: 'Apakah Anda yakin ingin logout?',
        buttonColor: Colors.red.shade700,
      ),
    ).then((value) async {
      if (value == true) {
        try {
          await _firebaseAuthService.signOut(context);

          await _prefs.clearAll();

          Get.offAll(const LoginScreen());
        } catch (e) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Log Out Error'),
              content: Text('Terjadi kesalahan saat logout: ${e.toString()}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    });
  }
}
