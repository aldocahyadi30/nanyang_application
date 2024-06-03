import 'package:flutter/material.dart';
import 'package:nanyang_application/module/announcement/screen/announcement_screen.dart';
import 'package:nanyang_application/module/attendance/screen/attendance_admin_screen.dart';
import 'package:nanyang_application/module/chat/screen/chat_list_screen.dart';
import 'package:nanyang_application/module/chat/screen/chat_screen.dart';
import 'package:nanyang_application/module/dashboard/widget/dashboard_menu.dart';
import 'package:nanyang_application/module/dashboard/widget/dashboard_menu_icon.dart';
import 'package:nanyang_application/module/management/screen/management_user_screen.dart';
import 'package:nanyang_application/module/salary/screen/salary_admin_screen.dart';
import 'package:nanyang_application/module/salary/screen/salary_user_screen.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/helper.dart';
import 'package:provider/provider.dart';

class DashboardMenuCard extends StatelessWidget {
  const DashboardMenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ConfigurationProvider config = Provider.of<ConfigurationProvider>(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(dynamicWidth(24, context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        margin: dynamicMargin(8, 8, 8, 8, context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            RichText(
              text: TextSpan(
                text: 'Halo, ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: dynamicFontSize(20, context),
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins',
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: config.shortenedName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: dynamicFontSize(20, context),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            if (config.user.level == 1) _userMenu(),
            if (config.user.level != 1) _adminMenu(),
          ],
        ),
      ),
    );
  }

  Widget _adminMenu() {
    return _buildMenu([
      const DashboardMenuIcon(image: 'assets/image/icon/menu/peformance.png', route: AttendanceAdminScreen(), title: 'Performance'),
      const DashboardMenuIcon(image: 'assets/image/icon/menu/gaji.png', route: SalaryAdminScreen(), title: 'Gaji'),
      const DashboardMenuIcon(image: 'assets/image/icon/menu/manajemen-pengguna.png', route: ManagementUserScreen(), title: 'Pengguna'),
      const DashboardMenuIcon(image: 'assets/image/icon/menu/pengumuman.png', route: AnnouncementScreen(), title: 'Pengumuman'),
      const DashboardMenuIcon(image: 'assets/image/icon/menu/chat.png', route: ChatListScreen(), title: 'Help Chat'),
      const DashboardMenu(),
    ]);
  }

  Widget _userMenu() {
    return _buildMenu([
      const DashboardMenuIcon(image: 'assets/image/icon/menu/peformance.png', route: AttendanceAdminScreen(), title: 'Performance'),
      const DashboardMenuIcon(image: 'assets/image/icon/menu/gaji.png', route: SalaryUserScreen(), title: 'Gaji'),
      const DashboardMenuIcon(image: 'assets/image/icon/menu/manajemen-pengguna.png', route: ManagementUserScreen(), title: 'Pengguna'),
      const DashboardMenuIcon(image: 'assets/image/icon/menu/pengumuman.png', route: AnnouncementScreen(), title: 'Pengumuman'),
      const DashboardMenuIcon(image: 'assets/image/icon/menu/chat.png', route: ChatScreen(), title: 'Help Chat'),
      const DashboardMenuIcon(image: 'assets/image/icon/menu/guidebook.png', route: AttendanceAdminScreen(), title: 'Guidebook'),
    ]);
  }

  Widget _buildMenu(List<Widget> items) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items.take(3).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items.skip(3).toList(),
        ),
      ],
    );
  }
}
