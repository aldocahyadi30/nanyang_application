import 'package:flutter/material.dart';
import 'dart:ui';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                Transform.translate(
                  offset: const Offset(-75, -50), // adjust as needed
                  child: Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 100, // adjust as needed
                      backgroundColor:
                          Colors.red.withOpacity(0.5), // adjust as needed
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(75, -50), // adjust as needed
                  child: Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 100, // adjust as needed
                      backgroundColor:
                          Colors.blue.withOpacity(0.5), // adjust as needed
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, 75), // adjust as needed
                  child: Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 100, // adjust as needed
                      backgroundColor:
                          Colors.green.withOpacity(0.5), // adjust as needed
                    ),
                  ),
                ),
                Center(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 50.0, sigmaY: 50.0), // adjust as needed
                    child: Image.asset(
                      'assets/image/logo-nanyang.png',
                      width: 175,
                      height: 175,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Text('Temporary'),
          ),
        ],
      ),
    );
  }
}