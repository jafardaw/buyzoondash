import 'dart:async';

import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/features/auth/presentation/view/login_view.dart';
import 'package:buyzoonapp/features/root/presentation/view/root_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    Timer(const Duration(seconds: 4), () async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                RootView(), // Replace with your main screen widget
          ),
        );
      }
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
              'assest/images/SAV_٢٠٢٥٠٩١٣_٠١٤٩٤٥-removebg-preview.png',
            ), // The image path
          ),
        ),
      ),
    );
  }
}
