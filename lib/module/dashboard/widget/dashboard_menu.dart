import 'package:flutter/material.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/module/chat/screen/chat_list_screen.dart';
import 'package:nanyang_application/module/dashboard/widget/dashboard_menu_icon.dart';
import 'package:nanyang_application/module/global/other/nanyang_coming_soon_placeholder.dart';
import 'package:nanyang_application/service/navigation_service.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:nanyang_application/viewmodel/calendar_viewmodel.dart';
import 'package:nanyang_application/viewmodel/employee_viewmodel.dart';
import 'package:nanyang_application/viewmodel/performance_viewmodel.dart';
import 'package:nanyang_application/viewmodel/salary_viewmodel.dart';
import 'package:nanyang_application/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const DashboardMenuIcon(image: 'assets/image/icon/menu/absensi.png', title: 'Absensi'),
                  const DashboardMenuIcon(image: 'assets/image/icon/menu/perizinan.png', title: 'Perizinan'),
                  DashboardMenuIcon(
                      image: 'assets/image/icon/menu/manajemen-pengguna.png',
                      onTap: () => context.read<UserViewModel>().index(),
                      title: 'Pengguna'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardMenuIcon(
                      image: 'assets/image/icon/menu/peformance.png',
                      onTap: () => context.read<PerformanceViewmodel>().index(),
                      title: 'Performance'),
                  DashboardMenuIcon(
                      image: 'assets/image/icon/menu/gaji.png',
                      onTap: () => context.read<SalaryViewModel>().index(),
                      title: 'Gaji'),
                  DashboardMenuIcon(
                      image: 'assets/image/icon/menu/kalender.png',
                      onTap: () => context.read<CalendarViewmodel>().index(),
                      title: 'Kalender'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardMenuIcon(
                      image: 'assets/image/icon/menu/pengumuman.png',
                      onTap: () => context.read<AnnouncementViewModel>().index(),
                      title: 'Pengumuman'),
                  DashboardMenuIcon(
                      image: 'assets/image/icon/menu/chat.png',
                      onTap: () => context.read<NavigationService>().navigateTo(const ChatListScreen()),
                      title: 'Help Chat'),
                  DashboardMenuIcon(
                      image: 'assets/image/icon/menu/guidebook.png',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NanyangComingSoonPlaceholder(title: 'Guidebook')));
                      },
                      title: 'Guidebook'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardMenuIcon(
                      image: 'assets/image/icon/menu/manajemen-karyawan.png',
                      onTap: () => context.read<EmployeeViewModel>().index(),
                      title: 'Karyawan'),
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
            Image.asset('assets/image/icon/menu/lainnya.png',
                width: dynamicWidth(52, context), height: dynamicHeight(52, context)),
            Text(
              'Lainnya',
              style:
                  TextStyle(color: Colors.black, fontSize: dynamicFontSize(12, context), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}