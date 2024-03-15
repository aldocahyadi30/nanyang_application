import 'package:flutter/material.dart';
import 'package:nanyang_application/widget/dashboard_menu_icon.dart';

class DashboardMenuCard extends StatelessWidget {
  const DashboardMenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/peformance.png',
                  route: '/performance',
                  title: 'Performance'),
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
                  route: '/announcement',
                  title: 'Pengumuman'),
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/chat.png',
                  route: '/chat',
                  title: 'Help Chat'),
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/lainnya.png',
                  route: '/menu',
                  title: 'Lainnya'),
            ],
          ),
        ],
      ),
    );
  }
}
