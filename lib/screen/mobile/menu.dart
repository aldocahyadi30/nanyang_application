import 'package:flutter/material.dart';
import 'package:nanyang_application/widget/dashboard/dashboard_menu_icon.dart';

import '../../widget/global/nanyang_appbar.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NanyangAppbar(
        title: 'Menu',
        isBackButton: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/absensi.png',
                  route: '/absensi',
                  title: 'Absensi'),
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/perizinan.png',
                  route: '/perizinan',
                  title: 'Perizinan'),
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/manajemen.png',
                  route: '/manajemen',
                  title: 'Manajemen'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/peformance.png',
                  route: '/peformance',
                  title: 'Peformance'),
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/gaji.png',
                  route: '/gaji',
                  title: 'Gaji'),
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/kalender.png',
                  route: '/kalender',
                  title: 'Kalender'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/pengumuman.png',
                  route: '/pengumuman',
                  title: 'Pengumuman'),
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/chat.png',
                  route: '/chat',
                  title: 'Help Chat'),
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/guidebook.png',
                  route: '/guidebook',
                  title: 'Guidebook'),
            ],
          ),
        ],
      ),
    );
  }
}