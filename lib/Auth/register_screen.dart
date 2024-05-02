import 'package:e_kantin/Auth/login_screen.dart';
import 'package:e_kantin/constant.dart';
import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/components/rounded_button.dart';
import 'package:e_kantin/viewmodel/auth_viewmodel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthViewModel _authViewModel = AuthViewModel();

  String phoneNum = "";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  Widget _buildRegisterForm() {
    return SizedBox(
      width: SizeConfig.screenWidth * 0.8,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: _phoneController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "";
                  } else if (value.isNotEmpty && value.length < 9) {
                    return "";
                  } else {
                    return null;
                  }
                },
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                  fontWeight: FontWeight.normal,
                ),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(8),
                    ),
                    child: Text(
                      "+62",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  hintText: "8xxx",
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(12),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  setState(
                    () {
                      phoneNum = value;
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: _nimController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nim Empty';
                  } else {
                    return null;
                  }
                },
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(
                  labelText: "NIM",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name Empty';
                  } else {
                    return null;
                  }
                },
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: _emailController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email Empty';
                  } else {
                    return null;
                  }
                },
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: TextFormField(
                controller: _passwordController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password Empty';
                  } else {
                    return null;
                  }
                },
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return RoundedButton(
      width: SizeConfig.screenWidth * 0.8,
      text: 'Sign Up',
      press: () async {
        await _authViewModel.signUp(
          _formKey,
          _nameController.text.trim(),
          _passwordController.text.trim(),
          _emailController.text.trim(),
          _phoneController.text.trim(),
          _nimController.text.trim(),
          context,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: SizeConfig.screenHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: getProportionateScreenHeight(50),
                left: getProportionateScreenWidth(10),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(45),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                      width: SizeConfig.screenWidth * 0.15,
                      height: SizeConfig.screenWidth * 0.15,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.005,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        // width: SizeConfig.screenWidth * 0.6,
                        child: Text(
                          "Sign Up",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenHeight(30),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.01,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.6,
                        child: Text(
                          "register by filling in the column below \nwith the appropriate data",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: getProportionateScreenHeight(18),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    _buildRegisterForm(),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth * 0.8,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                                text: 'By tapping "Register" you agree \n'),
                            TextSpan(
                              text: 'terms and conditions',
                              style: const TextStyle(color: kMainColor),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _buildSignUpButton(),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: getProportionateScreenHeight(10),
                      ),
                      child: SizedBox(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                  text: 'Already have an account? Sign In '),
                              TextSpan(
                                text: 'here',
                                style: const TextStyle(color: kMainColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
