import 'package:flutter/material.dart';
import 'package:nanyang_application/screen/mobile/setting/configuration/configuration_announcement_category.dart';
import '../../../../widget/global/nanyang_appbar.dart';
import '../../../../widget/configuration/configuration_item.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NanyangAppbar(
        title: 'Konfigurasi',
        isBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            ConfigurationItem(
              title: 'Pengumuman',
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.category, color: Colors.blue),
                  title: const Text(
                    'Kategori Pengumuman',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConfigurationAnnouncementCategoryScreen(isForm: false,),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            ConfigurationItem(
              title: 'Peforma',
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.calculate, color: Colors.blue),
                  title: const Text(
                    'Variabel Perhitungan',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  ),
                  onTap: () {},
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}