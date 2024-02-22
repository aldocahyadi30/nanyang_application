import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nanyang_application/provider/user_provider.dart';
import 'package:nanyang_application/screen/home.dart';
import 'package:nanyang_application/screen/menu.dart';
import 'package:nanyang_application/screen/splash.dart';
import 'package:nanyang_application/screen/login.dart';
import 'package:nanyang_application/service/announcement_service.dart';
import 'package:nanyang_application/service/auth_service.dart';
import 'package:nanyang_application/service/user_service.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:nanyang_application/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_preview/device_preview.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  await Supabase.initialize(
    url: 'https://ghglsfibxzedkzbcrocl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdoZ2xzZmlieHplZGt6YmNyb2NsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDcwOTk5NjIsImV4cCI6MjAyMjY3NTk2Mn0.IQ-3YBRNTGMo0wwhJrK1UFd6ljGYS_kq0q2-hItUhTE',
  );

  final hasSession = Supabase.instance.client.auth.currentSession != null;

  runApp(DevicePreview(
    enabled: true,
    builder: (context) => MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              LoginViewModel(authenticationService: AuthenticationService()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              AnnouncementViewModel(announcementService: AnnouncementService()),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context), // Add the locale here
        builder: (context, child) {
          return DevicePreview.appBuilder(
              context, FToastBuilder()(context, child));
        },
        title: 'Flutter Demo',
        theme: ThemeData(
            fontFamily: 'Roboto',
            primaryColor: Colors.white,
            navigationBarTheme: NavigationBarThemeData(
              labelTextStyle: MaterialStateProperty.all(
                const TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            )),
        navigatorKey: navigatorKey,
        initialRoute: hasSession ? '/home' : '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) {
            if (hasSession) {
              UserService()
                  .getUserByID(Supabase.instance.client.auth.currentUser!.id)
                  .then((userData) {
                if (context.mounted) {
                  Provider.of<UserProvider>(context, listen: false)
                      .setUser(userData);
                }
              }).catchError((error) {
                // Handle error if any
                print('Error fetching user data: $error');
              });
            }
            return const HomeScreen();
          },
          '/menu': (context) => const MenuScreen(),
        },
      ),
    ),
  ));
}
