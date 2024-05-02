import 'dart:async';

import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/utils/global_colors.dart';
import 'package:e_kantin/view/intro.view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 3),
      () => Get.to(() => const Intro()),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: GlobalColor.secondaryColor,
      body: Center(
        child: Image(
          image: const AssetImage('assets/logo.png'),
          width: getProportionateScreenWidth(200),
        ),
      ),
    );
  }
}
