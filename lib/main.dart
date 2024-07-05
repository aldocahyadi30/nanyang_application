import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nanyang_application/module/splash_screen.dart';
import 'package:nanyang_application/provider/color_provider.dart';
import 'package:nanyang_application/provider/date_provider.dart';
import 'package:nanyang_application/provider/file_provider.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/announcement_service.dart';
import 'package:nanyang_application/service/attendance_service.dart';
import 'package:nanyang_application/service/auth_service.dart';
import 'package:nanyang_application/service/calendar_service.dart';
import 'package:nanyang_application/service/chat_service.dart';
import 'package:nanyang_application/service/configuration_service.dart';
import 'package:nanyang_application/service/employee_service.dart';
import 'package:nanyang_application/service/firebase_service.dart';
import 'package:nanyang_application/service/navigation_service.dart';
import 'package:nanyang_application/service/performance_service.dart';
import 'package:nanyang_application/service/request_service.dart';
import 'package:nanyang_application/service/salary_service.dart';
import 'package:nanyang_application/service/user_service.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:nanyang_application/viewmodel/auth_viewmodel.dart';
import 'package:nanyang_application/viewmodel/calendar_viewmodel.dart';
import 'package:nanyang_application/viewmodel/chat_viewmodel.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:nanyang_application/viewmodel/date_viewmodel.dart';
import 'package:nanyang_application/viewmodel/employee_viewmodel.dart';
import 'package:nanyang_application/viewmodel/performance_viewmodel.dart';
import 'package:nanyang_application/viewmodel/request_viewmodel.dart';
import 'package:nanyang_application/viewmodel/salary_viewmodel.dart';
import 'package:nanyang_application/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_manager/window_manager.dart';

import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseService().initNotification();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      title: 'Nanyang App',
      size: Size(1024, 640),
      minimumSize: Size(1024, 640),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setAspectRatio(1024 / 640);
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(authenticationService: AuthenticationService()),
        ),
        ChangeNotifierProvider(
          create: (context) => UserViewModel(userService: UserService()),
        ),
        ChangeNotifierProvider(
          create: (context) => EmployeeViewModel(employeeService: EmployeeService()),
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
          create: (context) => ChatViewModel(chatService: ChatService()),
        ),
        ChangeNotifierProvider(
          create: (context) => SalaryViewModel(salaryService: SalaryService()),
        ),
        ChangeNotifierProvider(
          create: (context) => ConfigurationViewModel(configurationService: ConfigurationService()),
        ),
        ChangeNotifierProvider(
          create: (context) => PerformanceViewmodel(performanceService: PerformanceService()),
        ),
        ChangeNotifierProvider(
          create: (context) => CalendarViewmodel(calendarService: CalendarService()),
        ),
        ChangeNotifierProvider(
          create: (context) => DateViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ToastProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DateProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ColorProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FileProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NavigationService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return FToastBuilder()(context, child);
        },
        title: 'Nanyang Mobile',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Poppins',
          navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.all(
              const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        navigatorKey: navigatorKey,
        home: const SplashScreen(),
      ),
    ),
  );
}