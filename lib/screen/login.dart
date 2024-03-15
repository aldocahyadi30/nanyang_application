import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nanyang_application/widget/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double _opacity = 0.0; // Initial opacity value
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        _opacity = 1.0; // Set opacity to fully visible
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            fit: StackFit.loose,
            children: [
              Positioned(
                left: MediaQuery.of(context).size.width * 0.085, // 25% from left
                top: MediaQuery.of(context).size.height * 0.1, // 25% from top
                child: Hero(
                  tag: 'redAvatar',
                  child: CircleAvatar(
                    radius: 85,
                    backgroundColor: Colors.red.withOpacity(0.75),
                  ),
                ),
              ),
              // Avatar at top right
              Positioned(
                right: MediaQuery.of(context).size.width * 0.085, // 25% from right
                top: MediaQuery.of(context).size.height * 0.1, // 25% from top
                child: Hero(
                  tag: 'blueAvatar',
                  child: CircleAvatar(
                    radius: 85,
                    backgroundColor: Colors.blue.withOpacity(0.75),
                  ),
                ),
              ),
              // Avatar at bottom center
              Positioned(
                top: MediaQuery.of(context).size.height * 0.225, // 25% from bottom
                left: MediaQuery.of(context).size.width * 0.25, // 25% from left
                right: MediaQuery.of(context).size.width * 0.25, // 25% from right
                child: Hero(
                  tag: 'greenAvatar',
                  child: CircleAvatar(
                    radius: 85,
                    backgroundColor: Colors.green.withOpacity(0.75),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.15, // 25% from bottom
                left: MediaQuery.of(context).size.width * 0.25, // 25% from left
                right: MediaQuery.of(context).size.width * 0.25, // 25% from right
                child: Hero(
                  tag: 'logo',
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
                    child: Image.asset(
                      'assets/image/logo-nanyang.png',
                      width: 175,
                      height: 175,
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 1500),
                opacity: _opacity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.275,
                    ),
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Nanyang Mobile',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(padding: EdgeInsets.all(16.0), child: LoginForm()),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
