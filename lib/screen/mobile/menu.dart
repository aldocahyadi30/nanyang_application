import 'package:flutter/material.dart';
import 'package:nanyang_application/screen/mobile/announcement/announcement.dart';
import 'package:nanyang_application/screen/mobile/attendance/attendance.dart';
import 'package:nanyang_application/screen/mobile/request/request.dart';
import 'package:nanyang_application/widget/dashboard/dashboard_menu_icon.dart';

import '../../widget/global/nanyang_appbar.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NanyangAppbar(
        title: 'Menu',
        isBackButton:true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/absensi.png', route: AttendanceScreen(), title: 'Absensi'),
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/perizinan.png', route: RequestScreen(), title: 'Perizinan'),
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/manajemen.png',
                  route: AttendanceScreen(), //TODO : Temporarily using attendance screen
                  title: 'Manajemen'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/peformance.png',
                  route: AttendanceScreen(), //TODO : Temporarily using attendance screen
                  title: 'Peformance'),
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/gaji.png',
                  route: AttendanceScreen(), //TODO : Temporarily using attendance screen
                  title: 'Gaji'),
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/kalender.png',
                  route: AttendanceScreen(), //TODO : Temporarily using attendance screen
                  title: 'Kalender'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/pengumuman.png', route: AnnouncementScreen(), title: 'Pengumuman'),
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/chat.png',
                  route: AttendanceScreen(), //TODO : Temporarily using attendance screen
                  title: 'Help Chat'),
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/guidebook.png',
                  route: AttendanceScreen(), //TODO : Temporarily using attendance screen
                  title: 'Guidebook'),
            ],
          ),
        ],
      ),
    );
  }
}