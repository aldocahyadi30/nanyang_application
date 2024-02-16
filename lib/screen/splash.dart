import 'package:flutter/material.dart';
import 'dart:ui';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/image/logo-nanyang.png',
          width: 175,
          height: 175,
        ),
      )
    );
  }
}


