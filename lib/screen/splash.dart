import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nanyang_application/provider/user_provider.dart';
import 'package:nanyang_application/screen/login.dart';
import 'package:nanyang_application/screen/mobile/home.dart';
import 'package:nanyang_application/service/user_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0; // Initial opacity value

  @override
  void initState() {
    super.initState();
    // Start the fade-in animation after a delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _opacity = 1.0; // Set opacity to fully visible
      });
    });
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    if (Supabase.instance.client.auth.currentSession == null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const LoginScreen(),
          transitionDuration: const Duration(seconds: 3),
          transitionsBuilder: (context, animation, animation2, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    } else {
      await UserService()
          .getUserByID(Supabase.instance.client.auth.currentUser!.id)
          .then((userData) {
        if (mounted) {
          Provider.of<UserProvider>(context, listen: false).setUser(userData);
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => const HomeScreen(),
              transitionDuration: const Duration(seconds: 3),
              transitionsBuilder: (context, animation, animation2, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        }
      }).catchError((error) {
        debugPrint(error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            // Avatar at top left
            Positioned(
              left: MediaQuery.of(context).size.width * 0.085, // 25% from left
              top: MediaQuery.of(context).size.height * 0.33, // 25% from top
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _opacity,
                child: Hero(
                  tag: 'redAvatar',
                  child: CircleAvatar(
                    radius: 85,
                    backgroundColor: Colors.red.withOpacity(0.75),
                  ),
                ),
              ),
            ),
            // Avatar at top right
            Positioned(
              right:
                  MediaQuery.of(context).size.width * 0.085, // 25% from right
              top: MediaQuery.of(context).size.height * 0.33, // 25% from top
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _opacity,
                child: Hero(
                  tag: 'blueAvatar',
                  child: CircleAvatar(
                    radius: 85,
                    backgroundColor: Colors.blue.withOpacity(0.75),
                  ),
                ),
              ),
            ),
            // Avatar at bottom center
            Positioned(
              bottom:
                  MediaQuery.of(context).size.height * 0.32, // 25% from bottom
              left: MediaQuery.of(context).size.width * 0.25, // 25% from left
              right: MediaQuery.of(context).size.width * 0.25, // 25% from right
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _opacity,
                child: Hero(
                  tag: 'greenAvatar',
                  child: CircleAvatar(
                    radius: 85,
                    backgroundColor: Colors.green.withOpacity(0.75),
                  ),
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
          ],
        ),
      ),
    );
  }
}