import 'package:flutter/material.dart';
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
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                // Avatar at top left
                Positioned(
                  left: MediaQuery.of(context).size.width *
                      0.085, // 25% from left
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
                  right: MediaQuery.of(context).size.width *
                      0.085, // 25% from right
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
                  left:
                      MediaQuery.of(context).size.width * 0.25, // 25% from left
                  right: MediaQuery.of(context).size.width *
                      0.25, // 25% from right
                  child: Hero(
                    tag: 'greenAvatar',
                    child: CircleAvatar(
                      radius: 85,
                      backgroundColor: Colors.green.withOpacity(0.75),
                    ),
                  ),
                ),
                // Centered logo
                Center(
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

                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Nanyang Mobile',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          const Expanded(
            flex: 1,
            child: Form(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
