import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/module/attendance/screen/attendance_admin_screen.dart';
import 'package:nanyang_application/module/attendance/screen/attendance_user_screen.dart';
import 'package:nanyang_application/module/dashboard/screen/dashboard_screen.dart';
import 'package:nanyang_application/module/request/screen/request_screen.dart';
import 'package:nanyang_application/module/setting/screen/setting_screen.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  Color color = ColorTemplate.periwinkle;
  late final UserModel user;
  final DashboardScreen _dashboardScreen = const DashboardScreen();
  late final Widget _attendanceScreen;
  final RequestScreen _requestScreen = const RequestScreen(
    type: 'list',
  );
  final SettingScreen _settingScreen = const SettingScreen();

  @override
  void initState() {
    super.initState();
    user = context.read<ConfigurationViewModel>().user;
    _attendanceScreen = user.level == 1 ? const AttendanceUserScreen() : const AttendanceAdminScreen();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: currentPageIndex == 2 ? ColorTemplate.lightVistaBlue : ColorTemplate.periwinkle,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(dynamicWidth(25, context)),
            topRight: Radius.circular(dynamicWidth(25, context)),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: NavigationBar(
          selectedIndex: currentPageIndex,
          backgroundColor: ColorTemplate.violetBlue,
          indicatorColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          elevation: 0,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
              if (currentPageIndex == 1){
                context.read<AttendanceViewModel>().index();
              }
            });
          },
          destinations: <Widget>[
            NavigationDestination(
              selectedIcon: Icon(
                Icons.home_filled,
                color: Colors.white,
                size: dynamicWidth(40, context),
              ),
              icon: Icon(
                Icons.home_outlined,
                color: Colors.white,
                size: dynamicWidth(40, context),
              ),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.timer_rounded,
                color: Colors.white,
                size: dynamicWidth(40, context),
              ),
              icon: Icon(
                Icons.timer_outlined,
                color: Colors.white,
                size: dynamicWidth(40, context),
              ),
              label: 'Absensi',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.description,
                color: Colors.white,
                size: dynamicWidth(40, context),
              ),
              icon: Icon(
                Icons.description_outlined,
                color: Colors.white,
                size: dynamicWidth(40, context),
              ),
              label: 'Perizinan',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.settings,
                color: Colors.white,
                size: dynamicWidth(40, context),
              ),
              icon: Icon(
                Icons.settings_outlined,
                color: Colors.white,
                size: dynamicWidth(40, context),
              ),
              label: 'Pengaturan',
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: IndexedStack(
          index: currentPageIndex,
          children: [
            _dashboardScreen,
            _attendanceScreen,
            _requestScreen,
            _settingScreen,
          ],
        ),
      ),
    );
  }
}
