import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
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
                left:
                    MediaQuery.of(context).size.width * 0.085, // 25% from left
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
                right:
                    MediaQuery.of(context).size.width * 0.085, // 25% from right
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
                top: MediaQuery.of(context).size.height *
                    0.225, // 25% from bottom
                left: MediaQuery.of(context).size.width * 0.25, // 25% from left
                right:
                    MediaQuery.of(context).size.width * 0.25, // 25% from right
                child: Hero(
                  tag: 'greenAvatar',
                  child: CircleAvatar(
                    radius: 85,
                    backgroundColor: Colors.green.withOpacity(0.75),
                  ),
                ),
              ),
              // Centered logo
              Positioned(
                top: MediaQuery.of(context).size.height *
                    0.15, // 25% from bottom
                left: MediaQuery.of(context).size.width * 0.25, // 25% from left
                right:
                    MediaQuery.of(context).size.width * 0.25, // 25% from right
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
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
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                            ),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                            ),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Lupa Password?',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                      context,
                                      '/register',
                                    );
                                  },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                            ),
                            Container(
                              width: double.infinity,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Your code here...
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                                child: const Text(
                                  'Masuk',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
