import 'package:flutter/material.dart';
import 'package:nanyang_application/widget/setting_account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 4,
        automaticallyImplyLeading: false,
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
              style: TextStyle(
                  color: Colors.black,
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
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.notifications, color: Colors.white),
                  ),
                  title: const Text('Notifikasi'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(context, '/pengaturan-akun');
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.info, color: Colors.white),
                  ),
                  title: const Text('Tentang Aplikasi'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(context, '/pengaturan-akun');
                  },
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
            ),
          )
        ],
      ),
    );
  }
}
