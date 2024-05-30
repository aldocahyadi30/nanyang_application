import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/module/auth/screen/login_screen.dart';
import 'package:nanyang_application/module/home_screen.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:nanyang_application/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnnouncementViewModel>().getAnnouncementCategory();
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
        await Provider.of<UserViewModel>(context, listen: false)
          .getUserByID(Supabase.instance.client.auth.currentUser!.id)
          .then((userData) {
        Provider.of<ConfigurationProvider>(context, listen: false).setUser(userData);
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const HomeScreen(),
            transitionsBuilder: (context, animation, animation2, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      }).catchError((error) {
        debugPrint(error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      body: Center(
        child: Hero(
          tag: 'logo',
          child: Image.asset(
            'assets/image/logo-nanyang.png',
            width: 175,
            height: 175,
          ),
        ),
      ),
    );
  }
}