import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanyang_application/screen/absensi.dart';
import 'package:nanyang_application/screen/dashboard.dart';
import 'package:nanyang_application/screen/pengaturan.dart';
import 'package:nanyang_application/screen/perizinan.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  final DashboardScreen _dashboardScreen = const DashboardScreen();
  final AbsensiScreen _absensiScreen = const AbsensiScreen();
  final PerizinanScreen _perizinanScreen = const PerizinanScreen();
  final PengaturanScreen _pengaturanScreen = const PengaturanScreen();

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // top bar color
      statusBarIconBrightness: Brightness.light, // top bar icons
    ));

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey, // Change this to your desired color
              width: 0.7, // Change this to your desired width
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: currentPageIndex,
          backgroundColor: Colors.white,
          indicatorColor: Colors.blue,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          elevation: 0,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(
                Icons.home_filled,
                color: Colors.white,
                size: 28,
              ),
              icon: Icon(
                Icons.home_filled,
                color: Colors.blue,
                size: 28,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.timer_rounded,
                color: Colors.white,
                size: 28,
              ),
              icon: Icon(
                Icons.timer_outlined,
                color: Colors.blue,
                size: 28,
              ),
              label: 'Absensi',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.edit_document,
                color: Colors.white,
                size: 28,
              ),
              icon: Icon(
                Icons.edit_document,
                color: Colors.blue,
                size: 28,
              ),
              label: 'Perizinan',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.settings,
                color: Colors.white,
                size: 28,
              ),
              icon: Icon(
                Icons.settings,
                color: Colors.blue,
                size: 28,
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
            _absensiScreen,
            _perizinanScreen,
            _pengaturanScreen,
          ],
        ),
      ),
    );
  }
}
