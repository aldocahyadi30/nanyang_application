import 'package:flutter/material.dart';
import 'package:nanyang_application/screen/mobile/setting/configuration/configuration.dart';
import 'package:nanyang_application/widget/setting/setting_account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../widget/global/nanyang_appbar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NanyangAppbar(
        title: 'Pengaturan',
        isBackButton: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 28),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              'Akun',
              style: TextStyle(color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SettingAccount(),
          Divider(
            color: Colors.grey[300],
            height: 1,
          ),
          const SizedBox(height: 28),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              'Pengaturan',
              style: TextStyle(color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Column(
            children: [
              ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                        Icons.admin_panel_settings, color: Colors.white),
                  ),
                  title: const Text('Konfigurasi'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConfigurationScreen(),
                    ),
                  ),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.info, color: Colors.white),
                ),
                title: const Text('Tentang Aplikasi'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, '/pengaturan-akun'),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.exit_to_app, color: Colors.white),
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await Supabase.instance.client.auth.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}