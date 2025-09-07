import 'dart:async';

import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/app_router.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    Timer(const Duration(seconds: 4), () {
      AppRoutes.pushNamed(context, AppRoutes.login);
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder:
      //         (context) =>
      //             const LoginPage(), // Replace with your main screen widget
      //   ),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor, // Or any color you like
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(
            seconds: 1,
          ), // The duration of the fade-in animation
          curve: Curves.easeIn, // The animation curve
          child: SizedBox(
            height: 320,
            width: 320,
            child: Image.asset(
              'assest/images/SAVE_٢٠٢٥٠٨٢٩_٢٣٣٣٥١-removebg-preview.png',
            ), // The image path
          ),
        ),
      ),
    );
  }
}
