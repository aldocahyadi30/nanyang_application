import 'package:flutter/material.dart';
import 'package:nanyang_application/provider/user_provider.dart';
import 'package:nanyang_application/screen/mobile/announcement/announcement.dart';
import 'package:nanyang_application/screen/mobile/attendance/attendance.dart';
import 'package:nanyang_application/screen/mobile/menu.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/widget/dashboard/dashboard_menu_icon.dart';
import 'package:provider/provider.dart';

class DashboardMenuCard extends StatelessWidget {
  const DashboardMenuCard({super.key});

//TODO Not yet finished
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    String employeeName = Provider.of<UserProvider>(context).shortenedName!;

    return Card(
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          RichText(
            text: TextSpan(
              text: 'Halo, ' ,
              style: TextStyle(
                color: Colors.black,
                fontSize: dynamicFontSize(24, context),
                fontWeight: FontWeight.w800,
                fontFamily: 'Poppins',
              ),
              children:  <TextSpan>[
                TextSpan(
                  text: employeeName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: dynamicFontSize(24, context),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/peformance.png',
                  route: AttendanceScreen(), //TODO : Temporarily using attendance screen
                  title: 'Performance'),
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/pengumuman.png', route: AnnouncementScreen(), title: 'Pengumuman'),
              DashboardMenuIcon(
                  image: 'assets/image/icon/menu/chat.png',
                  route: AttendanceScreen(), //TODO : Temporarily using attendance screen
                  title: 'Help Chat'),
              DashboardMenuIcon(image: 'assets/image/icon/menu/lainnya.png', route: MenuScreen(), title: 'Lainnya'),
            ],
          ),
        ],
      ),
    );
  }
}