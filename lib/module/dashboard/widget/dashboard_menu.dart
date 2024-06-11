import 'package:flutter/material.dart';
import 'package:nanyang_application/module/announcement/screen/announcement_screen.dart';
import 'package:nanyang_application/module/attendance/screen/attendance_admin_screen.dart';
import 'package:nanyang_application/module/chat/screen/chat_list_screen.dart';
import 'package:nanyang_application/module/dashboard/widget/dashboard_menu_icon.dart';
import 'package:nanyang_application/module/management/screen/management_employee_screen.dart';
import 'package:nanyang_application/module/management/screen/management_user_screen.dart';
import 'package:nanyang_application/module/performance/screen/performance_admin_screen.dart';
import 'package:nanyang_application/module/request/screen/request_screen.dart';
import 'package:nanyang_application/module/salary/screen/salary_admin_screen.dart';
import 'package:nanyang_application/helper.dart';

class DashboardMenu extends StatefulWidget {
  const DashboardMenu({super.key});

  @override
  State<DashboardMenu> createState() => _DashboardMenuState();
}

class _DashboardMenuState extends State<DashboardMenu> {
  Future<void> _dashboardMenu(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(dynamicWidth(25, context)),
              topRight: Radius.circular(dynamicWidth(25, context)),
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: dynamicHeight(40, context)),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardMenuIcon(image: 'assets/image/icon/menu/absensi.png', route: AttendanceAdminScreen(), title: 'Absensi'),
                  DashboardMenuIcon(
                      image: 'assets/image/icon/menu/perizinan.png',
                      route: RequestScreen(
                        type: 'list',
                      ),
                      title: 'Perizinan'),
                  DashboardMenuIcon(image: 'assets/image/icon/menu/manajemen-pengguna.png', route: ManagementUserScreen(), title: 'Pengguna'),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardMenuIcon(
                      image: 'assets/image/icon/menu/peformance.png',
                      route: PerformanceAdminScreen(),
                      title: 'Peformance'),
                  DashboardMenuIcon(image: 'assets/image/icon/menu/gaji.png', route: SalaryAdminScreen(), title: 'Gaji'),
                  DashboardMenuIcon(
                      image: 'assets/image/icon/menu/kalender.png',
                      route: AttendanceAdminScreen(), //TODO : Temporarily using attendance screen
                      title: 'Kalender'),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardMenuIcon(image: 'assets/image/icon/menu/pengumuman.png', route: AnnouncementScreen(), title: 'Pengumuman'),
                  DashboardMenuIcon(
                      image: 'assets/image/icon/menu/chat.png',
                      route: ChatListScreen(), //TODO : Temporarily using attendance screen
                      title: 'Help Chat'),
                  DashboardMenuIcon(
                      image: 'assets/image/icon/menu/guidebook.png',
                      route: AttendanceAdminScreen(), //TODO : Temporarily using attendance screen
                      title: 'Guidebook'),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardMenuIcon(image: 'assets/image/icon/menu/manajemen-karyawan.png', route: ManagementEmployeeScreen(), title: 'Karyawan'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _dashboardMenu(context);
      },
      child: Container(
        width: dynamicWidth(96, context),
        height: dynamicHeight(80, context),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/image/icon/menu/lainnya.png', width: dynamicWidth(52, context), height: dynamicHeight(52, context)),
            Text(
              'Lainnya',
              style: TextStyle(color: Colors.black, fontSize: dynamicFontSize(12, context), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
