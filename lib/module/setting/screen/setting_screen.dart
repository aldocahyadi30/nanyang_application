import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/module/setting/screen/configuration_screen.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  void _logout(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorTemplate.periwinkle,
          title: const Text(
            'Logout',
            style: TextStyle(color: ColorTemplate.violetBlue, fontWeight: FontWeight.bold),
          ),
          content: const Text('Apakah anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await context.read<AuthViewModel>().logout();
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int level = Provider.of<ConfigurationProvider>(context).user.level;

    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      body: Stack(
        children: [
          Positioned(
            top: 0, // Adjust this value to position the card
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                color: ColorTemplate.violetBlue,
              ),
              child: Center(
                child: Padding(
                  padding: dynamicPaddingOnly(36, 0, 28, 28, context),
                  child: _buildAccount(context),
                ),
              ),
            ),
          ),
          Padding(
            padding: dynamicPaddingSymmetric(0, 16, context),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.225),
                Container(
                  padding: dynamicPaddingAll(4, context),
                  decoration: BoxDecoration(color: ColorTemplate.lightVistaBlue, borderRadius: BorderRadius.circular(25)),
                  child: Column(
                    children: [
                      _buildListTile(context, 'Notifikasi', Colors.white, Icons.notifications_none_outlined, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfigurationScreen()));
                      }),
                      if (level != 1)
                        _buildListTile(context, 'Konfigurasi', Colors.white, Icons.admin_panel_settings_outlined, () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfigurationScreen()));
                        }),
                      _buildListTile(context, 'Tentang Aplikasi', Colors.white, Icons.info_outline, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfigurationScreen()));
                      }),
                    ],
                  ),
                ),
                SizedBox(height: dynamicHeight(16, context)),
                Container(
                  padding: dynamicPaddingAll(4, context),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                  child: Column(
                    children: [
                      _buildListTile(context, 'Keluar', const Color(0xFFEB3223), Icons.logout, () => _logout(context))
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget _buildListTile(BuildContext context, String title, Color color, IconData icon, Function() onTap) {
  return ListTile(
    onTap: onTap,
    leading: Icon(icon, color: color),
    title: Text(
      title,
      style: TextStyle(color: color, fontSize: dynamicFontSize(16, context), fontWeight: FontWeight.w600),
    ),
    trailing: Icon(Icons.chevron_right, color: color),
  );
}

Widget _buildAccount(BuildContext context) {
  final user = Provider.of<ConfigurationProvider>(context).user;
  String avatarText = Provider.of<ConfigurationProvider>(context).avatarInitials;
  String employeeName = Provider.of<ConfigurationProvider>(context).shortenedName;

  return Row(
    children: [
      CircleAvatar(
        radius: dynamicWidth(40, context),
        backgroundColor: ColorTemplate.argentinianBlue,
        child: Text(avatarText, style: TextStyle(color: Colors.white, fontSize: dynamicFontSize(24, context))),
      ),
      SizedBox(width: dynamicWidth(28, context)),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            employeeName,
            style: TextStyle(
              color: Colors.white,
              fontSize: dynamicFontSize(20, context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            user.positionName,
            style: TextStyle(
              fontSize: dynamicFontSize(12, context),
              fontWeight: FontWeight.w700,
              color: ColorTemplate.uranianBlue,
            ),
          ),
        ],
      ),
    ],
  );
}