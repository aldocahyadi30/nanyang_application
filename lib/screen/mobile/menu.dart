import 'package:flutter/material.dart';
import 'package:nanyang_application/widget/dashboard_menu_icon.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[400],
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[200]!,
                Colors.blue,
                Colors.blue[700]!,
                Colors.blue[800]!
              ],
            ),
          ),
        ),
        title: const Text('Menu',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 4,
        automaticallyImplyLeading: false,
      ),
      body: const Column(
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
