import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/screen/mobile/attendance/attendance.dart';
import 'package:nanyang_application/screen/mobile/dashboard.dart';
import 'package:nanyang_application/screen/mobile/setting/setting.dart';
import 'package:nanyang_application/screen/mobile/request/request.dart';
import 'package:nanyang_application/size.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  final DashboardScreen _dashboardScreen = const DashboardScreen();
  final AttendanceScreen _attendanceScreen = const AttendanceScreen();
  final RequestScreen _requestScreen = const RequestScreen();
  final SettingScreen _settingScreen = const SettingScreen();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: ColorTemplate.secondaryColor,
      bottomNavigationBar: Container(
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(dynamicWidth(25, context)),
            topRight: Radius.circular(dynamicWidth(25, context)),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: NavigationBar(
          selectedIndex: currentPageIndex,
          backgroundColor: ColorTemplate.primaryColor,
          indicatorColor: ColorTemplate.primaryColor,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          elevation: 0,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
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