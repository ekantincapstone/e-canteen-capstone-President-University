import 'package:e_kantin/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:e_kantin/Auth/register_screen.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/components/rounded_button.dart';
import 'package:flutter/services.dart';
import 'package:e_kantin/viewmodel/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthViewModel _authViewModel = AuthViewModel();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: SizeConfig.screenHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(45),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                  width: SizeConfig.screenWidth * 0.22,
                  height: SizeConfig.screenWidth * 0.22,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Welcome to \nE-Canteen",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getProportionateScreenHeight(42),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Log in with the registered \nemail and password.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: getProportionateScreenHeight(18),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email Empty';
                          }
                          return null;
                        },
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.normal,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.singleLineFormatter,
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      TextFormField(
                        controller: _passwordController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password Empty';
                          }
                          return null;
                        },
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.normal,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.singleLineFormatter,
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(30),
                  ),
                  child: Flexible(
                    child: const Text(
                      'By pressing "Sign In" you agree to the terms and conditions',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                RoundedButton(
                  width: SizeConfig.screenWidth * 0.8,
                  text: 'Sign In',
                  press: () async {
                    await _authViewModel.signIn(
                      _formKey,
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                      context,
                    );
                  },
                ),
                SizedBox(
                  child: Text.rich(
                    TextSpan(
                      text: 'New User? Register ',
                      children: [
                        TextSpan(
                          text: 'here',
                          style: const TextStyle(color: kMainColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
