import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nanyang_application/provider/date_provider.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/provider/user_provider.dart';
import 'package:nanyang_application/screen/login.dart';
import 'package:nanyang_application/screen/mobile/announcement/announcement.dart';
import 'package:nanyang_application/screen/mobile/announcement/announcement_create.dart';
import 'package:nanyang_application/screen/mobile/attendance/attendance.dart';
import 'package:nanyang_application/screen/mobile/attendance/attendance_labor_detail.dart';
import 'package:nanyang_application/screen/mobile/home.dart';
import 'package:nanyang_application/screen/mobile/menu.dart';
import 'package:nanyang_application/screen/mobile/setting/setting.dart';
import 'package:nanyang_application/screen/mobile/setting/setting_configuration.dart';
import 'package:nanyang_application/screen/mobile/setting/setting_configuration_detail.dart';
import 'package:nanyang_application/screen/splash.dart';
import 'package:nanyang_application/service/announcement_service.dart';
import 'package:nanyang_application/service/attendance_service.dart';
import 'package:nanyang_application/service/auth_service.dart';
import 'package:nanyang_application/service/request_service.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:nanyang_application/viewmodel/login_viewmodel.dart';
import 'package:nanyang_application/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Supabase.initialize(
    url: 'https://ghglsfibxzedkzbcrocl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdoZ2xzZmlieHplZGt6YmNyb2NsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDcwOTk5NjIsImV4cCI6MjAyMjY3NTk2Mn0.IQ-3YBRNTGMo0wwhJrK1UFd6ljGYS_kq0q2-hItUhTE',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(authenticationService: AuthenticationService()),
        ),
        ChangeNotifierProvider(
          create: (context) => AnnouncementViewModel(announcementService: AnnouncementService()),
        ),
        ChangeNotifierProvider(
          create: (context) => RequestViewModel(requestService: RequestService()),
        ),
        ChangeNotifierProvider(
          create: (context) => AttendanceViewModel(attendanceService: AttendanceService()),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ToastProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DateProvider(),
        ),
      ],
      child: MaterialApp(
        builder: (context, child) {
          return FToastBuilder()(context, child);
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue[100]),
              overlayColor: MaterialStateProperty.all(Colors.blue),
            ),
          ),
          useMaterial3: true,
          fontFamily: 'Poppins',
          primaryColor: Colors.white,
          primarySwatch: Colors.blue,
          navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(
                color: Colors.blue,
                fontSize: 12,
              ),
            ),
          ),
        ),
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/menu': (context) => const MenuScreen(),
          '/attendance': (context) => const AttendanceScreen(),
          '/attendance/detail': (context) => const AbsensiDetailScreen(),
          '/announcement': (context) => const AnnouncementScreen(),
          '/announcement/create': (context) => const AnnouncementDetailScreen(),
          '/setting' : (context) => const SettingScreen(),
          '/setting/configuration': (context) => const SettingConfigurationScreen(),
          '/setting/configuration/detail': (context) => const SettingConfigurationDetailScreen(),
        },
      ),
    ),
  );
}