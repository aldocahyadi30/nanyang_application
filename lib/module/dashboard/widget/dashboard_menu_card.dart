import 'package:flutter/material.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/module/chat/screen/chat_list_screen.dart';
import 'package:nanyang_application/module/chat/screen/chat_screen.dart';
import 'package:nanyang_application/module/dashboard/widget/dashboard_menu.dart';
import 'package:nanyang_application/module/dashboard/widget/dashboard_menu_icon.dart';
import 'package:nanyang_application/module/global/other/nanyang_coming_soon_placeholder.dart';
import 'package:nanyang_application/service/navigation_service.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:nanyang_application/viewmodel/auth_viewmodel.dart';
import 'package:nanyang_application/viewmodel/calendar_viewmodel.dart';
import 'package:nanyang_application/viewmodel/performance_viewmodel.dart';
import 'package:nanyang_application/viewmodel/salary_viewmodel.dart';
import 'package:nanyang_application/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class DashboardMenuCard extends StatelessWidget {
  const DashboardMenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<AuthViewModel>(context).user;

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
                    text: user.employee.shortedName,
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
            if (user.level == 1) _userMenu(context),
            if (user.level != 1) _adminMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _adminMenu(BuildContext context) {
    return _buildMenu([
      DashboardMenuIcon(
          image: 'assets/image/icon/menu/peformance.png',
          onTap: () => context.read<PerformanceViewmodel>().index(),
          title: 'Performa'),
      DashboardMenuIcon(
          image: 'assets/image/icon/menu/gaji.png',
          onTap: () => context.read<SalaryViewModel>().index(),
          title: 'Gaji'),
      DashboardMenuIcon(
          image: 'assets/image/icon/menu/manajemen-pengguna.png',
          onTap: () => context.read<UserViewModel>().index(),
          title: 'Pengguna'),
      DashboardMenuIcon(
          image: 'assets/image/icon/menu/pengumuman.png',
          onTap: () => context.read<AnnouncementViewModel>().index(),
          title: 'Pengumuman'),
      DashboardMenuIcon(
          image: 'assets/image/icon/menu/chat.png',
          onTap: () => context.read<NavigationService>().navigateTo(const ChatListScreen()),
          title: 'Help Chat'),
      const DashboardMenu(),
    ]);
  }

  Widget _userMenu(BuildContext context) {
    return _buildMenu([
      DashboardMenuIcon(
          image: 'assets/image/icon/menu/peformance.png',
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NanyangComingSoonPlaceholder(title: 'Performa')));
          },
          title: 'Performa'),
      DashboardMenuIcon(
          image: 'assets/image/icon/menu/gaji.png',
          onTap: () => context.read<SalaryViewModel>().index(),
          title: 'Gaji'),
      DashboardMenuIcon(
          image: 'assets/image/icon/menu/pengumuman.png',
          onTap: () => context.read<AnnouncementViewModel>().index(),
          title: 'Pengumuman'),
      DashboardMenuIcon(
          image: 'assets/image/icon/menu/chat.png',
          onTap: () => context.read<NavigationService>().navigateTo(const ChatScreen()),
          title: 'Help Chat'),
      DashboardMenuIcon(
          image: 'assets/image/icon/menu/guidebook.png',
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NanyangComingSoonPlaceholder(title: 'Guidebook')));
          },
          title: 'Guidebook'),
      DashboardMenuIcon(
          image: 'assets/image/icon/menu/kalender.png',
          onTap: () => context.read<CalendarViewmodel>().index(),
          title: 'Kalender'),
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