import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/module/auth/widget/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double _opacity = 0.0; // Initial opacity value

  @override
  void initState() {
    super.initState();
    // Delay setting opacity to 1.0 for the fade-in effect
    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        _opacity = 1.0; // Set opacity to fully visible
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [ColorTemplate.periwinkle, ColorTemplate.violetBlue],
                stops: [0.3, 0.9],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                Padding(padding: dynamicPaddingOnly(120, 0, 0, 0, context)),
                Hero(
                  tag: 'logo',
                  child: SvgPicture.asset(
                    'assets/svg/logo.svg',
                    width: dynamicHeight(175, context),
                    height: dynamicWidth(175, context),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 1500),
                  opacity: _opacity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: dynamicHeight(24, context)),
                      const Text(
                        'Nanyang Mobile',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: ColorTemplate.violetBlue,
                        ),
                      ),
                      SizedBox(height: dynamicHeight(16, context)),
                      Padding(
                        padding: dynamicPaddingSymmetric(0, 24, context),
                        child: const LoginForm(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}