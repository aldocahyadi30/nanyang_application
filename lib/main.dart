import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nanyang_application/provider/user_provider.dart';
import 'package:nanyang_application/screen/home.dart';
import 'package:nanyang_application/screen/splash.dart';
import 'package:nanyang_application/screen/login.dart';
import 'package:nanyang_application/service/auth_service.dart';
import 'package:nanyang_application/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  await Supabase.initialize(
    url: 'https://ghglsfibxzedkzbcrocl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdoZ2xzZmlieHplZGt6YmNyb2NsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDcwOTk5NjIsImV4cCI6MjAyMjY3NTk2Mn0.IQ-3YBRNTGMo0wwhJrK1UFd6ljGYS_kq0q2-hItUhTE',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              LoginViewModel(authenticationService: AuthenticationService()),
        ),
        // Add more providers as needed
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Roboto',
        ),
        builder: FToastBuilder(),
        navigatorKey: navigatorKey,
        initialRoute: Supabase.instance.client.auth.currentSession != null
            ? '/home'
            : '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
